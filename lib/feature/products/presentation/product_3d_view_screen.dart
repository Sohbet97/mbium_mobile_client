import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../core/themes/app_colors.dart';

class Product3dViewScreen extends StatefulWidget {
  const Product3dViewScreen({super.key, required this.modelUrl, this.title});

  final String modelUrl;
  final String? title;

  @override
  State<Product3dViewScreen> createState() => _Product3dViewScreenState();
}

class _Product3dViewScreenState extends State<Product3dViewScreen> {
  final _dio = Dio();
  Directory? _tempDir;
  String? _localPath;
  double? _progress;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _downloadModel();
  }

  Future<void> _downloadModel() async {
    try {
      // Скачиваем нативно (Dio), т.к. WebView внутри ModelViewer упирается
      // в CORS при прямой загрузке .glb с внешнего домена.
      final dir = await Directory.systemTemp.createTemp('mbium_3d_');
      _tempDir = dir;
      final fileName = widget.modelUrl.split('/').last;
      final filePath = '${dir.path}/$fileName';

      await _dio.download(
        widget.modelUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (!mounted || total <= 0) return;
          setState(() => _progress = received / total);
        },
      );

      if (mounted) setState(() => _localPath = filePath);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _tempDir?.delete(recursive: true).ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.navWhite),
        title: Text(
          widget.title ?? '3D',
          style: const TextStyle(color: AppColors.navWhite),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_failed) {
      return const Center(
        child: Text(
          'Не удалось загрузить 3D-модель',
          style: TextStyle(color: AppColors.navWhite),
        ),
      );
    }

    if (_localPath == null) {
      final progress = _progress;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 3,
                color: AppColors.navWhite,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              progress != null ? '${(progress * 100).toStringAsFixed(0)}%' : '',
              style: const TextStyle(color: AppColors.navWhite),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: ModelViewer(
        backgroundColor: Colors.black,
        src: 'file://$_localPath',
        alt: widget.title,
        ar: true,
        autoRotate: true,
        cameraControls: true,
        disableZoom: false,
        loading: Loading.eager,
      ),
    );
  }
}
