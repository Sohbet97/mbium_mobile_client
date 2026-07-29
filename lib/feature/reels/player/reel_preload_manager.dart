import 'dart:async';

import 'package:flutter/widgets.dart';

import 'reel_player_pool.dart';

/// Watches raw [PageController] scroll position (not just onPageChanged) so
/// the next/previous reel can start initializing before the user finishes
/// the swipe, instead of only after the page settles.
class ReelPreloadManager {
  ReelPreloadManager({
    required this.pageController,
    required this.playerPool,
    required this.videoUrlsProvider,
    this.anticipationThreshold = 0.35,
    this.settleDelay = const Duration(milliseconds: 150),
  }) {
    pageController.addListener(_onScroll);
  }

  final PageController pageController;
  final ReelPlayerPool playerPool;
  final List<String> Function() videoUrlsProvider;
  final double anticipationThreshold;
  final Duration settleDelay;

  Timer? _settleTimer;
  double? _lastPage;
  int? _lastAnticipatedIndex;

  void _onScroll() {
    if (!pageController.hasClients) return;
    final page = pageController.page;
    if (page == null) return;

    final movingForward = _lastPage == null ? true : page > _lastPage!;
    _lastPage = page;

    final baseIndex = page.floor();
    final fraction = page - baseIndex;

    int? anticipated;
    if (movingForward && fraction >= anticipationThreshold) {
      anticipated = baseIndex + 1;
    } else if (!movingForward && fraction <= (1 - anticipationThreshold)) {
      anticipated = baseIndex;
    }

    if (anticipated != null && anticipated != _lastAnticipatedIndex) {
      _lastAnticipatedIndex = anticipated;
      playerPool.warm(anticipated, videoUrlsProvider());
    }
  }

  void onPageSettleCandidate(int index) {
    _settleTimer?.cancel();
    _settleTimer = Timer(settleDelay, () {
      playerPool.focus(index, videoUrlsProvider());
    });
  }

  void dispose() {
    _settleTimer?.cancel();
    pageController.removeListener(_onScroll);
  }
}
