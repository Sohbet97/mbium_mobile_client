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
  // True while the current photo is zoomed in. Toggled once per completed
  // zoom gesture (not per-frame) — arena membership for a touch is decided
  // the moment it lands, so this has to reflect state *before* the next
  // touch starts rather than react mid-gesture.
  bool _pagingLocked = false;

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

  void _setPagingLocked(bool locked) {
    if (locked == _pagingLocked) return;
    setState(() => _pagingLocked = locked);
  }

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
                physics: _pagingLocked
                    ? const NeverScrollableScrollPhysics()
                    : const PageScrollPhysics(),
                itemCount: widget.media.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (_, i) => _MediaPageItem(
                  media: widget.media[i],
                  isActive: i == _currentIndex,
                  onLockPaging: _setPagingLocked,
                ),
              ),
              _TopBar(
                currentIndex: _currentIndex,
                total: widget.media.length,
                onClose: () => Navigator.pop(context),
                opacity: _showUI ? 1.0 : 0.0,
              ),
              if (widget.media.length > 1)
                _BottomThumbs(
                  media: widget.media,
                  selectedIndex: _currentIndex,
                  onTap: (i) => _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  opacity: _showUI ? 1.0 : 0.0,
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
  final ValueChanged<bool> onLockPaging;

  const _MediaPageItem({
    required this.media,
    required this.isActive,
    required this.onLockPaging,
  });

  @override
  State<_MediaPageItem> createState() => _MediaPageItemState();
}

class _MediaPageItemState extends State<_MediaPageItem>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _initialized = false;
  final _transformController = TransformationController();
  late final AnimationController _zoomAnimController;
  Offset? _doubleTapPosition;
  // Whether the image is currently zoomed past 1x. Drives both
  // [InteractiveViewer.panEnabled] (only pan the photo once zoomed in — at
  // 1x a single-finger drag is left free for the gallery's own page swipe)
  // and the gallery's [PageView] physics (locked out while zoomed, so
  // panning around a zoomed photo doesn't also flip pages). Both need this
  // decided *before* the next touch lands — toggling mid-gesture is too
  // late, since gesture-arena membership for a pointer is fixed the moment
  // it goes down.
  bool _isZoomed = false;

  bool get _isVideo => widget.media.media.type == 'video';

  @override
  void initState() {
    super.initState();
    if (_isVideo) _initVideo();
    _zoomAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
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
    _transformController.dispose();
    _zoomAnimController.dispose();
    super.dispose();
  }

  void _setZoomed(bool zoomed) {
    if (zoomed == _isZoomed) return;
    setState(() => _isZoomed = zoomed);
    widget.onLockPaging(zoomed);
  }

  void _onImageInteractionEnd(ScaleEndDetails details) {
    final scale = _transformController.value.getMaxScaleOnAxis();
    _setZoomed(scale > 1.01);
  }

  void _onDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
  }

  void _onDoubleTap() {
    final position = _doubleTapPosition;
    if (position == null) return;

    final zoomingIn = !_isZoomed;
    final endMatrix = zoomingIn
        ? (Matrix4.identity()
            ..translateByDouble(position.dx, position.dy, 0, 1)
            ..scaleByDouble(3.0, 3.0, 3.0, 1)
            ..translateByDouble(-position.dx, -position.dy, 0, 1))
        : Matrix4.identity();

    final animation =
        Matrix4Tween(begin: _transformController.value, end: endMatrix).animate(
          CurvedAnimation(parent: _zoomAnimController, curve: Curves.easeOut),
        );
    void listener() => _transformController.value = animation.value;
    animation.addListener(listener);
    _zoomAnimController
      ..reset()
      ..forward().whenCompleteOrCancel(
        () => animation.removeListener(listener),
      );

    _setZoomed(zoomingIn);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideo) {
      return GestureDetector(
        onDoubleTapDown: _onDoubleTapDown,
        onDoubleTap: _onDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformController,
          minScale: 1.0,
          maxScale: 4.0,
          // panEnabled is deliberately left at its default (true): setting
          // it to false still makes InteractiveViewer consume the gesture
          // (its own docs say onInteractionEnd fires "even if disabled"),
          // it just applies no transform — so at 1x that dead-ends the
          // touch instead of releasing it to the gallery's PageView, which
          // is what broke plain swiping. Left at true, a swipe at 1x has
          // nowhere to pan to (boundaryMargin is zero) and falls through
          // to the PageView as before; only once actually zoomed in does
          // panning have real bounds to consume the drag.
          onInteractionEnd: _onImageInteractionEnd,
          child: Center(
            child: ProductNetworkImage(
              url: widget.media.url,
              fit: BoxFit.contain,
              backgroundColor: Colors.black,
            ),
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
              backgroundColor: Colors.black,
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
  final double opacity;

  const _TopBar({
    required this.currentIndex,
    required this.total,
    required this.onClose,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    // AnimatedOpacity has to live *inside* this Positioned, not wrap it from
    // outside — Positioned requires a Stack as its direct render parent, and
    // an externally-wrapping AnimatedOpacity (with its own RenderObject)
    // breaks that adjacency.
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 200),
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
      ),
    );
  }
}

// ─── Bottom thumbnails ────────────────────────────────────────────────────────

class _BottomThumbs extends StatelessWidget {
  final List<ProductMedia> media;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double opacity;

  const _BottomThumbs({
    required this.media,
    required this.selectedIndex,
    required this.onTap,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    // Same reasoning as _TopBar: AnimatedOpacity must be inside this
    // Positioned so Positioned's direct render parent stays the Stack.
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 200),
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
                          backgroundColor: Colors.black,
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
      ),
    );
  }
}
