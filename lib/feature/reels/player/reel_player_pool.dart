import 'package:flutter/foundation.dart';

import 'reel_player_wrapper.dart';

/// Keeps at most 2 native video players alive at once: the current reel plus
/// a single neighbor pre-warmed in whichever direction the feed is
/// scrolling. Whenever the current index moves, everything outside the new
/// {current} (or {current, anticipated neighbor}) set is disposed
/// immediately, so memory/CPU usage stays flat no matter how long the feed
/// gets.
class ReelPlayerPool extends ChangeNotifier {
  final Map<int, ReelPlayerWrapper> _wrappers = {};
  int? _currentIndex;

  ReelPlayerWrapper? wrapperFor(int index) => _wrappers[index];

  void warm(int index, List<String> videoUrls) {
    if (index < 0 || index >= videoUrls.length) return;
    if (_wrappers.containsKey(index)) return;

    _evictOutside({?_currentIndex, index});
    _wrappers[index] = ReelPlayerWrapper(videoUrls[index])..initialize();
    notifyListeners();
  }

  Future<void> focus(int currentIndex, List<String> videoUrls) async {
    if (currentIndex < 0 || currentIndex >= videoUrls.length) return;
    _currentIndex = currentIndex;
    _evictOutside({currentIndex});

    final wrapper = _wrappers.putIfAbsent(
      currentIndex,
      () => ReelPlayerWrapper(videoUrls[currentIndex]),
    );
    notifyListeners();

    await wrapper.initialize();
    if (_currentIndex != currentIndex) return;
    await wrapper.play();

    for (final entry in _wrappers.entries) {
      if (entry.key != currentIndex) {
        await entry.value.pause();
      }
    }
  }

  void _evictOutside(Set<int> keep) {
    final toRemove = _wrappers.keys.where((i) => !keep.contains(i)).toList();
    for (final index in toRemove) {
      _wrappers.remove(index)?.dispose();
    }
  }

  /// Drops every live player without disposing the pool itself — for
  /// reuse across e.g. a tab switch that resets the feed to a fresh list.
  void reset() {
    _evictOutside(const {});
    _currentIndex = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final wrapper in _wrappers.values) {
      wrapper.dispose();
    }
    _wrappers.clear();
    super.dispose();
  }
}
