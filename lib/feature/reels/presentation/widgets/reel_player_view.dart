import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../models/reels_model.dart';
import '../../player/reel_player_wrapper.dart';

class ReelPlayerView extends StatefulWidget {
  const ReelPlayerView({super.key, required this.reel, required this.player});

  final ReelsModel reel;
  final ReelPlayerWrapper? player;

  @override
  State<ReelPlayerView> createState() => _ReelPlayerViewState();
}

class _ReelPlayerViewState extends State<ReelPlayerView> {
  @override
  void initState() {
    super.initState();
    widget.player?.addListener(_onPlayerChanged);
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
    final player = widget.player;
    if (player == null || player.controller == null) return;
    if (player.state == ReelPlayerLifecycleState.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  @override
  void dispose() {
    widget.player?.removeListener(_onPlayerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final controller = player?.controller;
    final isReady = controller != null && controller.value.isInitialized;
    final thumbnailUrl = widget.reel.thumbnail?.thumbnailUrl;

    return GestureDetector(
      onTap: _togglePlayback,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
            Image.network(thumbnailUrl, fit: BoxFit.cover)
          else
            const ColoredBox(color: Colors.black),
          if (isReady)
            FittedBox(
              fit: BoxFit.cover,
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
              child: Icon(Icons.error_outline, color: Colors.white, size: 48),
            ),
          Container(color: Colors.black26),
          if (isReady)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding: EdgeInsets.zero,
                colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white38,
                  backgroundColor: Colors.white12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
