import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reel_bottom_scrim.dart';
import 'package:video_player/video_player.dart';

import '../../models/reels_model.dart';
import '../../player/reel_player_wrapper.dart';

class ReelPlayerView extends StatefulWidget {
  const ReelPlayerView({
    super.key,
    required this.reel,
    required this.player,
    this.onDoubleTapLike,
    this.onScreenTap,
    this.fit = BoxFit.cover,
    this.showProgressBar = true,
  });

  final ReelsModel reel;
  final ReelPlayerWrapper? player;

  /// `cover` (default) fills the frame edge-to-edge, cropping overflow —
  /// the normal full-screen reel. `contain` shows the whole video
  /// letterboxed — used while the comments panel has shrunk the video, so
  /// TikTok-style you see the full frame rather than a cropped-in zoom.
  final BoxFit fit;

  /// Hidden while the comments panel is open — not useful (or roomy enough)
  /// alongside it.
  final bool showProgressBar;

  /// Called once per double-tap-to-like gesture (never on the "un-like" path
  /// — mirrors TikTok, where double tap only ever likes).
  final VoidCallback? onDoubleTapLike;

  /// Called on a single tap before the play/pause toggle runs. Return true
  /// to consume the tap (e.g. the caption was expanded and should just
  /// collapse) — the toggle is then skipped for that tap.
  final bool Function()? onScreenTap;

  @override
  State<ReelPlayerView> createState() => _ReelPlayerViewState();
}

class _ReelPlayerViewState extends State<ReelPlayerView>
    with TickerProviderStateMixin {
  late final AnimationController _heartController;
  late final Animation<double> _heartScale;
  late final Animation<double> _heartOpacity;
  Offset? _heartPosition;
  Offset? _pendingDoubleTapPosition;

  bool _showPlayPauseIcon = false;
  IconData _playPauseIcon = Icons.play_arrow_rounded;
  Timer? _playPauseHideTimer;

  static const double _fastForwardSpeed = 2.0;
  bool _isFastForward = false;

  late final AnimationController _speedBadgeController;
  late final Animation<double> _speedBadgeScale;
  late final Animation<double> _speedBadgeOpacity;

  /// Continuous breathing loop on the chevrons while fast-forward is held —
  /// only running (not just invisible) while active, to avoid burning
  /// frames on an idle reel.
  late final AnimationController _chevronPulseController;
  late final Animation<double> _chevronOffset;

  @override
  void initState() {
    super.initState();
    widget.player?.addListener(_onPlayerChanged);

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 40),
    ]).animate(_heartController);
    _heartOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_heartController);

    _speedBadgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _speedBadgeScale = CurvedAnimation(
      parent: _speedBadgeController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    ).drive(Tween(begin: 0.6, end: 1.0));
    _speedBadgeOpacity = CurvedAnimation(
      parent: _speedBadgeController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    _chevronPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _chevronOffset = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_chevronPulseController);
  }

  @override
  void didUpdateWidget(covariant ReelPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.player != oldWidget.player) {
      oldWidget.player?.removeListener(_onPlayerChanged);
      widget.player?.addListener(_onPlayerChanged);
    }
  }

  void _onPlayerChanged() {
    if (mounted) setState(() {});
  }

  void _togglePlayback() {
    if (widget.onScreenTap?.call() ?? false) return;

    final player = widget.player;
    if (player == null || player.controller == null) return;

    _playPauseHideTimer?.cancel();

    if (player.state == ReelPlayerLifecycleState.playing) {
      player.pause();
      // Paused: the icon is the affordance to resume, so keep it visible.
      setState(() {
        _playPauseIcon = Icons.play_arrow_rounded;
        _showPlayPauseIcon = true;
      });
    } else {
      player.play();
      // Resumed: flash the pause icon briefly, then fade it away.
      setState(() {
        _playPauseIcon = Icons.pause_rounded;
        _showPlayPauseIcon = true;
      });
      _playPauseHideTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showPlayPauseIcon = false);
      });
    }
  }

  void _startFastForward() {
    final controller = widget.player?.controller;
    if (controller == null || !controller.value.isInitialized) return;

    HapticFeedback.selectionClick();
    controller.setPlaybackSpeed(_fastForwardSpeed);
    setState(() => _isFastForward = true);
    _speedBadgeController.forward();
    _chevronPulseController.repeat();
  }

  void _stopFastForward() {
    if (!_isFastForward) return;

    final controller = widget.player?.controller;
    if (controller != null && controller.value.isInitialized) {
      controller.setPlaybackSpeed(1.0);
    }
    setState(() => _isFastForward = false);
    _speedBadgeController.reverse();
    _chevronPulseController.stop();
  }

  void _onDoubleTapDown(TapDownDetails details) {
    _pendingDoubleTapPosition = details.localPosition;
  }

  void _onDoubleTap() {
    final position = _pendingDoubleTapPosition;
    if (position == null) return;

    HapticFeedback.mediumImpact();
    setState(() => _heartPosition = position);
    _heartController.forward(from: 0);
    widget.onDoubleTapLike?.call();
  }

  @override
  void dispose() {
    if (_isFastForward) {
      final controller = widget.player?.controller;
      if (controller != null && controller.value.isInitialized) {
        controller.setPlaybackSpeed(1.0);
      }
    }
    widget.player?.removeListener(_onPlayerChanged);
    _heartController.dispose();
    _speedBadgeController.dispose();
    _chevronPulseController.dispose();
    _playPauseHideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final controller = player?.controller;
    final isReady = controller != null && controller.value.isInitialized;
    final thumbnailUrl = widget.reel.thumbnail?.thumbnailUrl;

    return Column(
      children: [
        Expanded(
          // Scoped to just the video area so it never fights the progress
          // bar's own drag/tap-to-seek gestures below for the same pointer.
          child: GestureDetector(
            onTap: _togglePlayback,
            onDoubleTapDown: _onDoubleTapDown,
            onDoubleTap: _onDoubleTap,
            onLongPressStart: (_) => _startFastForward(),
            onLongPressEnd: (_) => _stopFastForward(),
            onLongPressCancel: _stopFastForward,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
                  CachedNetworkImage(imageUrl: thumbnailUrl, fit: widget.fit)
                else
                  const ColoredBox(color: Colors.black),
                if (isReady)
                  FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                if (player?.state == ReelPlayerLifecycleState.initializing)
                  const Center(child: CircularProgressIndicator()),
                if (player?.state == ReelPlayerLifecycleState.error)
                  const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                if (_heartPosition != null) _buildDoubleTapHeart(),
                _buildPlayPauseIcon(),
                _buildSpeedBadge(),
              ],
            ),
          ),
        ),
        const ReelBottomScrim(),
        if (isReady && widget.showProgressBar) _buildProgressBar(controller),
      ],
    );
  }

  void _seekProgressTo(
    VideoPlayerController controller,
    double dx,
    double width,
  ) {
    if (!controller.value.isInitialized || width <= 0) return;
    final duration = controller.value.duration;
    if (duration == Duration.zero) return;

    final fraction = (dx / width).clamp(0.0, 1.0);
    controller.seekTo(duration * fraction);
  }

  /// [VideoProgressIndicator]'s own scrub gesture only covers its thin
  /// render box — too small to reliably grab with a finger — so scrubbing
  /// is driven here instead, over a properly sized 24px touch target, with
  /// the indicator itself left purely visual (`allowScrubbing: false`).
  Widget _buildProgressBar(VideoPlayerController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              _seekProgressTo(controller, details.localPosition.dx, width),
          onHorizontalDragUpdate: (details) =>
              _seekProgressTo(controller, details.localPosition.dx, width),
          child: Container(
            height: 24,
            alignment: Alignment.center,
            child: VideoProgressIndicator(
              controller,
              allowScrubbing: false,
              padding: EdgeInsets.zero,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white38,
                backgroundColor: Colors.white12,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Triangle wave in [0.3, 1.0]: peaks at [phase] == 0.5, dips at the ends —
  /// drives each chevron's opacity so they chase one another.
  double _chevronOpacityAt(double phase) {
    final wrapped = phase % 1.0;
    final wave = wrapped < 0.5 ? wrapped * 2 : (1 - wrapped) * 2;
    return 0.3 + 0.7 * wave;
  }

  Widget _buildSpeedBadge() {
    return Center(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _speedBadgeController,
            _chevronPulseController,
          ]),
          builder: (context, child) {
            return Opacity(
              opacity: _speedBadgeOpacity.value,
              child: Transform.scale(
                scale: _speedBadgeScale.value,
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.secondaryGreen.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _chevronPulseController,
                  builder: (context, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final phase = _chevronOffset.value + i * 0.28;
                        return Opacity(
                          opacity: _chevronOpacityAt(phase),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.secondaryGreen,
                            size: 18,
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(width: 2),
                Text(
                  '${_fastForwardSpeed.toStringAsFixed(0)}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseIcon() {
    return Center(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _showPlayPauseIcon ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
            ),
            child: Icon(_playPauseIcon, color: Colors.white, size: 56),
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleTapHeart() {
    const size = 70.0;
    final position = _heartPosition!;

    return Positioned(
      left: position.dx - size / 2,
      top: position.dy - size / 2,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _heartController,
          builder: (context, child) {
            return Opacity(
              opacity: _heartOpacity.value,
              child: Transform.scale(scale: _heartScale.value, child: child),
            );
          },
          child: const Icon(
            Icons.star,
            color: Color.fromARGB(255, 233, 178, 29),
            size: size,
            shadows: [Shadow(color: Colors.black38, blurRadius: 12)],
          ),
        ),
      ),
    );
  }
}
