import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/main.dart';
import 'package:video_player/video_player.dart';

class ShopDetailVideoWidget extends StatefulWidget {
  final ShopDetailModel model;

  const ShopDetailVideoWidget({super.key, required this.model});

  @override
  State<ShopDetailVideoWidget> createState() => _ShopDetailVideoWidgetState();
}

class _ShopDetailVideoWidgetState extends State<ShopDetailVideoWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  bool get _hasVideo =>
      widget.model.videoUrl != null && widget.model.videoUrl!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_hasVideo) _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(myMediaUrl + widget.model.videoUrl!),
    );
    _controller = controller;
    try {
      await controller.initialize();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    controller.setLooping(true);
    setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  void _openFullScreen() {
    final controller = _controller;
    if (controller == null || !_initialized) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ShopDetailFullScreenVideoPage(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasVideo) return const SizedBox.shrink();

    final controller = _controller;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 120,
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.black),
            if (_initialized && controller != null)
              GestureDetector(
                onTap: _togglePlay,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              )
            else
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: _openFullScreen,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fullscreen,
                    color: AppColors.navWhite,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopDetailFullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;

  const _ShopDetailFullScreenVideoPage({required this.controller});

  @override
  State<_ShopDetailFullScreenVideoPage> createState() =>
      _ShopDetailFullScreenVideoPageState();
}

class _ShopDetailFullScreenVideoPageState
    extends State<_ShopDetailFullScreenVideoPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    widget.controller.play();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: AppColors.navWhite),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppColors.primaryGreen,
                  bufferedColor: Colors.white38,
                  backgroundColor: Colors.white12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
