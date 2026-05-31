import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class MyHelpers {
  Future<File?> openImagePicker(BuildContext context) async {
    final localization = S.of(context);
    void _showImagePicker({required bool isCamera}) async {
      return null;
    }

    final result = await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Column(
          children: [
            const SizedBox(height: 3),
            Container(
              height: 2,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              onTap: () => _showImagePicker(isCamera: true),
              title: Text(localization.camera),
              leading: Icon(Icons.camera_alt),
              trailing: Icon(Icons.arrow_right),
            ),

            ListTile(
              onTap: () => _showImagePicker(isCamera: false),
              title: Text(localization.gallery),
              leading: Icon(Icons.image_search),
              trailing: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> showAlertDialog(
    BuildContext context,
    String title,
    String content,
    IconData? icon,
    Color? iconColor,
  ) async {
    final t = S.of(context);
    return showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(content),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.yes),
          ),
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.no, style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  static Future<void> showMessage(
    String text,
    Color backgroundColor,
    BuildContext context,
  ) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(text, style: TextStyle(color: Colors.white)),
            backgroundColor: backgroundColor,
            showCloseIcon: true,
          ),
        );
    });
  }
}
