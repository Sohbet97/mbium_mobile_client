import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/main.dart';
import 'package:video_player/video_player.dart';

class ShopDetailHeaderWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailHeaderWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _ShopDetailBannerWidget(model: model),
            Positioned(
              left: 16,
              bottom: -30,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.navWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: model.logo != null && model.logo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          myMediaUrl + model.logo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.store_outlined,
                            color: AppColors.primaryGreen,
                            size: 30,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.store_outlined,
                        color: AppColors.primaryGreen,
                        size: 30,
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      model.localizedName,
                      style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (model.isVerified == true) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      color: AppColors.bonusBannerTextGreen,
                      size: 18,
                    ),
                  ],
                ],
              ),
              if (model.type?.name != null) ...[
                const SizedBox(height: 4),
                Text(
                  model.type!.name!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (model.rating != null) ...[
                    const Icon(
                      Icons.star,
                      color: AppColors.starYellow,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text('${model.rating}/5', style: textStyles.s13w600clBlack),
                    const SizedBox(width: 8),
                    const Text(
                      '·',
                      style: TextStyle(color: AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (model.address != null && model.address!.isNotEmpty)
                    Text(
                      model.address!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShopDetailBannerWidget extends StatefulWidget {
  final ShopDetailModel model;

  const _ShopDetailBannerWidget({required this.model});

  @override
  State<_ShopDetailBannerWidget> createState() => _ShopDetailBannerWidgetState();
}

class _ShopDetailBannerWidgetState extends State<_ShopDetailBannerWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _muted = true;

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
    controller
      ..setLooping(true)
      ..setVolume(0)
      ..play();
    setState(() => _initialized = true);
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
      _controller?.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final showVideo = _hasVideo && _initialized && _controller != null;

    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.primaryGreen,
            child: model.logo != null && model.logo!.isNotEmpty
                ? Image.network(
                    myMediaUrl + model.logo!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: child,
                      );
                    },
                  )
                : null,
          ),
          if (showVideo)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          if (showVideo)
            Positioned(
              right: 10,
              bottom: 10,
              child: GestureDetector(
                onTap: _toggleMute,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _muted ? Icons.volume_off : Icons.volume_up,
                    color: AppColors.navWhite,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
