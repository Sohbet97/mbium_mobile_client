import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class RfqImageWidget extends StatefulWidget {
  const RfqImageWidget({super.key});

  @override
  State<RfqImageWidget> createState() => _RfqImageWidgetState();
}

class _RfqImageWidgetState extends State<RfqImageWidget> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  void _showPickerOptions() {
    final l10n = S.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.navBarGrey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primaryGreen),
                title: Text(l10n.gallery),
                onTap: () async {
                  Navigator.pop(context);
                  final images = await _picker.pickMultiImage();
                  if (images.isNotEmpty) {
                    setState(() => _images.addAll(images));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined,
                    color: AppColors.primaryGreen),
                title: Text(l10n.camera),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await _picker.pickImage(
                      source: ImageSource.camera);
                  if (image != null) {
                    setState(() => _images.add(image));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _showPickerOptions,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_photo_alternate_outlined,
                    color: AppColors.navWhite, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.surat_gos,
                  style: const TextStyle(
                    color: AppColors.navWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_images[index].path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _images.removeAt(index)),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.errorRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: AppColors.navWhite, size: 14),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}