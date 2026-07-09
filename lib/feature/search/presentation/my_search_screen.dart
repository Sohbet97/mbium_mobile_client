import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/search/model/search_model.dart';
import 'package:mbium_mobile_client/feature/search/presentation/widget/camera_and_gallery_detect.dart';

import '../../../generated/l10n.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({super.key, required this.searchModel});
  final SearchModel searchModel;
  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      body: widget.searchModel.isImageDetect == true
          ? CameraAndGalleryDetectWidget(
              onImageSelected: (value) {
                print('image selected');
              },
            )
          : SizedBox.shrink(),
    );
  }
}
