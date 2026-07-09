import 'package:flutter/material.dart';

/// Attached to [MaterialApp.scaffoldMessengerKey] in main.dart so plain Dart
/// code (like the Dio error interceptor) can show a SnackBar without needing
/// a BuildContext.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showGlobalMessage(String message, {bool isError = true}) {
  final messenger = scaffoldMessengerKey.currentState;
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
      ),
    );
}
