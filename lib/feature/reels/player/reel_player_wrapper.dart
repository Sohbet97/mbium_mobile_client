import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum ReelPlayerLifecycleState {
  idle,
  initializing,
  ready,
  playing,
  paused,
  error,
}

/// Keeps the screen awake while at least one reel is actively playing.
/// Reference-counted (not a plain on/off toggle) because the pool can briefly
/// hold two wrappers mid-transition — e.g. [ReelPlayerPool.focus] starts the
/// new current reel playing *before* it pauses the old one, so a naive
/// "pause disables" call on the old wrapper would turn the screen-sleep
/// timer back on even though the new reel is still playing.
class _ReelWakelock {
  static int _activeCount = 0;

  static void acquire() {
    _activeCount++;
    if (_activeCount == 1) {
      WakelockPlus.enable();
    }
  }

  static void release() {
    if (_activeCount == 0) return;
    _activeCount--;
    if (_activeCount == 0) {
      WakelockPlus.disable();
    }
  }
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
    final wasPlaying = _state == ReelPlayerLifecycleState.playing;
    _state = value;
    notifyListeners();

    final isPlaying = value == ReelPlayerLifecycleState.playing;
    if (isPlaying && !wasPlaying) {
      _ReelWakelock.acquire();
    } else if (!isPlaying && wasPlaying) {
      _ReelWakelock.release();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _startBackgroundCacheIfNeeded();
    if (_state == ReelPlayerLifecycleState.playing) {
      _ReelWakelock.release();
    }
    super.dispose();
  }
}
