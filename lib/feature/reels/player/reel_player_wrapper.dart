import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

enum ReelPlayerLifecycleState {
  idle,
  initializing,
  ready,
  playing,
  paused,
  error,
}

class ReelVideoCacheManager extends CacheManager {
  static const key = 'reelsVideoCache';

  static final ReelVideoCacheManager _instance = ReelVideoCacheManager._();
  factory ReelVideoCacheManager() => _instance;

  ReelVideoCacheManager._()
    : super(
        Config(key, stalePeriod: const Duration(days: 7), maxNrOfCacheObjects: 60),
      );
}

class ReelPlayerWrapper extends ChangeNotifier {
  ReelPlayerWrapper(this.videoUrl, {BaseCacheManager? cacheManager})
    : _cacheManager = cacheManager ?? ReelVideoCacheManager();

  final String videoUrl;
  final BaseCacheManager _cacheManager;

  VideoPlayerController? _controller;
  VideoPlayerController? get controller => _controller;

  ReelPlayerLifecycleState _state = ReelPlayerLifecycleState.idle;
  ReelPlayerLifecycleState get state => _state;

  bool _isCacheMiss = false;
  bool _cacheDownloadStarted = false;

  Future<void> initialize() async {
    if (_controller != null || videoUrl.isEmpty) return;

    _setState(ReelPlayerLifecycleState.initializing);

    try {
      final cached = await _cacheManager.getFileFromCache(videoUrl);
      final VideoPlayerController controller;
      _isCacheMiss = cached == null;
      if (cached != null) {
        controller = VideoPlayerController.file(cached.file);
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      }
      _controller = controller;

      await controller.initialize();
      await controller.setLooping(true);
      _setState(ReelPlayerLifecycleState.ready);
    } catch (_) {
      _setState(ReelPlayerLifecycleState.error);
    }
  }

  Future<void> play() async {
    if (_controller == null) return;
    try {
      await _controller!.play();
      _setState(ReelPlayerLifecycleState.playing);
    } catch (_) {
      _setState(ReelPlayerLifecycleState.error);
    }
  }

  Future<void> pause() async {
    if (_controller == null) return;
    await _controller!.pause();
    _setState(ReelPlayerLifecycleState.paused);
    _startBackgroundCacheIfNeeded();
  }

  void _startBackgroundCacheIfNeeded() {
    if (_isCacheMiss && !_cacheDownloadStarted && videoUrl.isNotEmpty) {
      _cacheDownloadStarted = true;
      _cacheManager.getSingleFile(videoUrl).ignore();
    }
  }

  void _setState(ReelPlayerLifecycleState value) {
    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _startBackgroundCacheIfNeeded();
    super.dispose();
  }
}
