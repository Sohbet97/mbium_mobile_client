import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static final ReceivePort _port = ReceivePort();

  static Future<void> init() async {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_port');

    _port.listen((dynamic data) async {
      String id = data[0];
      DownloadTaskStatus status = data[1];

      if (status == DownloadTaskStatus.complete) {
        final tasks = await FlutterDownloader.loadTasks();
        final task = tasks?.firstWhere((t) => t.taskId == id);

        if (task != null) {
          final filePath = "${task.savedDir}/${task.filename}";
          OpenFile.open(filePath);
        }
      }
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(
      'downloader_port',
    );
    send?.send([id, DownloadTaskStatus.values[status], progress]);
  }

  static Future<void> download(String url) async {
    await Permission.storage.request();

    await FlutterDownloader.enqueue(
      url: url,
      savedDir: "/storage/emulated/0/Download",
      fileName: url.split('/').last,
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
  }
}
