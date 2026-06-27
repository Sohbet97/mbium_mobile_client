import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

class ProductSpinViewWidget extends StatefulWidget {
  final List<ProductMedia> spinMedia;
  final double height;

  const ProductSpinViewWidget({
    super.key,
    required this.spinMedia,
    this.height = 280,
  });

  @override
  State<ProductSpinViewWidget> createState() => _ProductSpinViewWidgetState();
}

class _ProductSpinViewWidgetState extends State<ProductSpinViewWidget> {
  int _frameIndex = 0;
  bool _isDragging = false;
  bool _hintShown = false;

  // Сколько пикселей нужно провести для смены одного кадра
  static const double _pixelsPerFrame = 12.0;
  double _dragAccumulator = 0.0;

  List<ProductMedia> get _frames => widget.spinMedia;

  void _onDragStart(DragStartDetails _) {
    setState(() {
      _isDragging = true;
      _hintShown = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragAccumulator += details.delta.dx;

    final steps = (_dragAccumulator / _pixelsPerFrame).truncate();
    if (steps == 0) return;

    _dragAccumulator -= steps * _pixelsPerFrame;

    setState(() {
      _frameIndex =
          (_frameIndex - steps) % _frames.length; // drag right = rotate right
      if (_frameIndex < 0) _frameIndex += _frames.length;
    });
  }

  void _onDragEnd(DragEndDetails _) {
    setState(() {
      _isDragging = false;
      _dragAccumulator = 0.0;
    });
  }

  void _openFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductSpinFullScreen(
          spinMedia: _frames,
          initialIndex: _frameIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_frames.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ...List.generate(_frames.length, (i) {
                return Offstage(
                  offstage: i != _frameIndex,
                  child: Image.network(
                    _frames[i].url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                );
              }),

              Positioned(
                top: 8,
                left: 8,
                child: _SpinBadge(frameCount: _frames.length),
              ),

              // Fullscreen button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _openFullScreen,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: AppColors.navWhite,
                      size: 20,
                    ),
                  ),
                ),
              ),

              AnimatedOpacity(
                opacity: _isDragging ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(child: _DragHint(shown: !_hintShown)),
                ),
              ),

              if (_isDragging)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_frameIndex + 1} / ${_frames.length}',
                      style: const TextStyle(
                        color: AppColors.navWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
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

class _SpinBadge extends StatelessWidget {
  final int frameCount;

  const _SpinBadge({required this.frameCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.threesixty, color: AppColors.navWhite, size: 16),
          const SizedBox(width: 4),
          Text(
            '360°',
            style: const TextStyle(
              color: AppColors.navWhite,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DragHint extends StatelessWidget {
  final bool shown;

  const _DragHint({required this.shown});

  @override
  Widget build(BuildContext context) {
    if (!shown) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.swipe, color: AppColors.navWhite, size: 16),
          SizedBox(width: 6),
          Text(
            'Öwürmek üçin süýşüriň',
            style: TextStyle(color: AppColors.navWhite, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ─── Full screen 360° ─────────────────────────────────────────────────────────

class ProductSpinFullScreen extends StatefulWidget {
  final List<ProductMedia> spinMedia;
  final int initialIndex;

  const ProductSpinFullScreen({
    super.key,
    required this.spinMedia,
    this.initialIndex = 0,
  });

  @override
  State<ProductSpinFullScreen> createState() => _ProductSpinFullScreenState();
}

class _ProductSpinFullScreenState extends State<ProductSpinFullScreen> {
  late int _frameIndex;
  bool _hintShown = true;
  bool _showUI = true;

  static const double _pixelsPerFrame = 10.0;
  double _dragAccumulator = 0.0;

  List<ProductMedia> get _frames => widget.spinMedia;

  @override
  void initState() {
    super.initState();
    _frameIndex = widget.initialIndex;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onDragStart(DragStartDetails _) {
    setState(() {
      _hintShown = true;
      _showUI = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragAccumulator += details.delta.dx;
    final steps = (_dragAccumulator / _pixelsPerFrame).truncate();
    if (steps == 0) return;
    _dragAccumulator -= steps * _pixelsPerFrame;
    setState(() {
      _frameIndex = (_frameIndex - steps) % _frames.length;
      if (_frameIndex < 0) _frameIndex += _frames.length;
    });
  }

  void _onDragEnd(DragEndDetails _) {
    setState(() {
      _dragAccumulator = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showUI = !_showUI),
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Кадры
            ...List.generate(_frames.length, (i) {
              return Offstage(
                offstage: i != _frameIndex,
                child: Image.network(
                  _frames[i].url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              );
            }),

            // Top bar
            Positioned(
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
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.navWhite),
                    ),
                    const Spacer(),
                    _SpinBadge(frameCount: _frames.length),
                    const SizedBox(width: 8),
                    Text(
                      '${_frameIndex + 1} / ${_frames.length}',
                      style: const TextStyle(
                        color: AppColors.navWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom hint
            AnimatedOpacity(
              opacity: (_showUI && !_hintShown) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 24,
                left: 0,
                right: 0,
                child: const Center(child: _DragHint(shown: true)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
