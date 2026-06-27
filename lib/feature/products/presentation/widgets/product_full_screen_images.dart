import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_images_widget.dart';
import 'package:video_player/video_player.dart';

class ProductFullScreenImages extends StatefulWidget {
  final List<ProductMedia> media;
  final int initialIndex;

  const ProductFullScreenImages({
    super.key,
    required this.media,
    this.initialIndex = 0,
  });

  @override
  State<ProductFullScreenImages> createState() =>
      _ProductFullScreenImagesState();
}

class _ProductFullScreenImagesState extends State<ProductFullScreenImages> {
  late int _currentIndex;
  late PageController _pageController;
  bool _showUI = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleUI() => setState(() => _showUI = !_showUI);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.grey),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: _toggleUI,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.media.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (_, i) => _MediaPageItem(
                  media: widget.media[i],
                  isActive: i == _currentIndex,
                ),
              ),
              AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _TopBar(
                  currentIndex: _currentIndex,
                  total: widget.media.length,
                  onClose: () => Navigator.pop(context),
                ),
              ),
              if (widget.media.length > 1)
                AnimatedOpacity(
                  opacity: _showUI ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: _BottomThumbs(
                    media: widget.media,
                    selectedIndex: _currentIndex,
                    onTap: (i) => _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Media page item (image or video) ────────────────────────────────────────

class _MediaPageItem extends StatefulWidget {
  final ProductMedia media;
  final bool isActive;

  const _MediaPageItem({required this.media, required this.isActive});

  @override
  State<_MediaPageItem> createState() => _MediaPageItemState();
}

class _MediaPageItemState extends State<_MediaPageItem> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  bool get _isVideo => widget.media.media.type == 'video';

  @override
  void initState() {
    super.initState();
    if (_isVideo) _initVideo();
  }

  @override
  void didUpdateWidget(_MediaPageItem old) {
    super.didUpdateWidget(old);
    // Пауза когда страница не активна
    if (!widget.isActive && _controller?.value.isPlaying == true) {
      _controller?.pause();
    }
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.media.url),
    );
    _controller = controller;
    await controller.initialize();
    if (mounted) setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideo) {
      return InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        child: Center(
          child: ProductNetworkImage(
            url: widget.media.url,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    if (!_initialized || _controller == null) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ProductNetworkImage(
              url: widget.media.thumbnailUrl,
              fit: BoxFit.contain,
            ),
            const CircularProgressIndicator(color: AppColors.primaryGreen),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller!.value.isPlaying
              ? _controller!.pause()
              : _controller!.play();
        });
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller!),
              if (!_controller!.value.isPlaying)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColors.navWhite,
                    size: 48,
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  _controller!,
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
      ),
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback onClose;

  const _TopBar({
    required this.currentIndex,
    required this.total,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          right: 16,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close, color: AppColors.navWhite),
            ),
            const Spacer(),
            Text(
              '${currentIndex + 1} / $total',
              style: const TextStyle(
                color: AppColors.navWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom thumbnails ────────────────────────────────────────────────────────

class _BottomThumbs extends StatelessWidget {
  final List<ProductMedia> media;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomThumbs({
    required this.media,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 12,
          top: 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        child: SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: media.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final isSelected = i == selectedIndex;
              final isVideo = media[i].media.type == 'video';
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.white.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ProductNetworkImage(
                          url: media[i].thumbnailUrl,
                          width: 56,
                          height: 56,
                        ),
                        if (isVideo)
                          Container(
                            color: Colors.black.withValues(alpha: 0.3),
                            child: const Icon(
                              Icons.play_circle_outline,
                              color: AppColors.navWhite,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
