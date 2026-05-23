import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({
    super.key,
    required this.message,
    required this.onReload,
  });
  final String message;
  final VoidCallback onReload;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(10),
            child: Text(message),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: onReload,
              child: Text(S.of(context).refresh),
            ),
          ),
        ],
      ),
    );
  }
}
