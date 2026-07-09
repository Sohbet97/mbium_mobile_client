import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class CameraAndGalleryDetectWidget extends StatefulWidget {
  const CameraAndGalleryDetectWidget({super.key, this.onImageSelected});

  final ValueChanged<File>? onImageSelected;

  @override
  State<CameraAndGalleryDetectWidget> createState() =>
      _CameraAndGalleryDetectWidgetState();
}

class _CameraAndGalleryDetectWidgetState
    extends State<CameraAndGalleryDetectWidget>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> _cameras = const [];
  int _selectedCameraIndex = 0;
  String? _errorMessage;
  FlashMode _flashMode = FlashMode.off;

  List<AssetEntity> _galleryAssets = const [];
  bool _galleryLoading = false;
  bool _galleryDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    // Android/iOS won't show two native permission dialogs at once — if a
    // second request fires while the first is still open it gets silently
    // denied. Requesting camera then gallery access one after another avoids
    // that race.
    await _setupCamera();
    await _loadGalleryAssets();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraController(_cameras[_selectedCameraIndex]);
      if (_galleryDenied) {
        _galleryDenied = false;
        _loadGalleryAssets();
      }
    }
  }

  Future<void> _setupCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _errorMessage = 'no_camera_permission');
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'no_camera_found');
        return;
      }
      _cameras = cameras;
      await _initCameraController(_cameras[_selectedCameraIndex]);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _initCameraController(CameraDescription description) async {
    final previous = _controller;
    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    final initializeFuture = controller.initialize();
    setState(() {
      _controller = controller;
      _initializeControllerFuture = initializeFuture;
      _errorMessage = null;
      _flashMode = FlashMode.off;
    });
    await previous?.dispose();
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initCameraController(_cameras[_selectedCameraIndex]);
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final next = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    try {
      await controller.setFlashMode(next);
      setState(() => _flashMode = next);
    } catch (_) {}
  }

  Future<void> _capturePhoto() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }
    final file = await controller.takePicture();
    widget.onImageSelected?.call(File(file.path));
  }

  Future<void> _loadGalleryAssets() async {
    if (_galleryLoading) return;
    _galleryLoading = true;
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.hasAccess) {
        if (mounted) setState(() => _galleryDenied = true);
        return;
      }
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (albums.isEmpty) {
        if (mounted) setState(() => _galleryDenied = false);
        return;
      }
      final assets = await albums.first.getAssetListPaged(page: 0, size: 90);
      if (!mounted) return;
      setState(() {
        _galleryAssets = assets;
        _galleryDenied = false;
      });
    } catch (_) {
      if (mounted) setState(() => _galleryDenied = true);
    } finally {
      _galleryLoading = false;
    }
  }

  Future<void> _selectAsset(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null) {
      widget.onImageSelected?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildError(_errorMessage!);
    }

    final controller = _controller;
    final initializeFuture = _initializeControllerFuture;
    if (controller == null || initializeFuture == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final isBackCamera =
        _cameras.isNotEmpty &&
        _cameras[_selectedCameraIndex].lensDirection ==
            CameraLensDirection.back;

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<void>(
            future: initializeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              return Center(child: CameraPreview(controller));
            },
          ),

          Positioned(
            left: 8,
            right: 8,
            top: 8,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  Row(
                    children: [
                      if (isBackCamera)
                        IconButton(
                          onPressed: _toggleFlash,
                          icon: Icon(
                            _flashMode == FlashMode.torch
                                ? Icons.flash_on
                                : Icons.flash_off,
                            color: _flashMode == FlashMode.torch
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                      if (_cameras.length > 1)
                        IconButton(
                          onPressed: _switchCamera,
                          icon: const Icon(
                            Icons.cameraswitch,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.28,
            minChildSize: 0.28,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [0.28, 0.9],
            builder: (context, scrollController) {
              return DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: _capturePhoto,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white54,
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Галерея',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    if (_galleryDenied)
                      SliverToBoxAdapter(
                        child: _buildGalleryPermissionState(context),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final asset = _galleryAssets[index];
                            return _GalleryThumbnail(
                              asset: asset,
                              onTap: () => _selectAsset(asset),
                            );
                          }, childCount: _galleryAssets.length),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryPermissionState(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primary.withOpacity(0.35), primary.withOpacity(0.1)],
              ),
            ),
            child: Icon(Icons.photo_library_outlined, color: primary, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Доступ к галерее закрыт',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Разрешите доступ к фото, чтобы выбирать изображения из галереи прямо здесь',
            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary.withOpacity(0.85), primary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => openAppSettings(),
                  child: const Center(
                    child: Text(
                      'Открыть доступ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() => _galleryDenied = false);
              _loadGalleryAssets();
            },
            child: const Text(
              'Обновить',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white54,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => _errorMessage = null);
                  _setupCamera();
                },
                child: const Text('Повторить'),
              ),
              TextButton(
                onPressed: () => openAppSettings(),
                child: const Text(
                  'Открыть настройки',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryThumbnail extends StatelessWidget {
  const _GalleryThumbnail({required this.asset, required this.onTap});

  final AssetEntity asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FutureBuilder<Uint8List?>(
        future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Container(color: Colors.grey.shade900);
          }
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        },
      ),
    );
  }
}
