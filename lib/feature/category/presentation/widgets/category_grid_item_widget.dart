import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';

class CategoryGridItemWidget extends StatelessWidget {
  const CategoryGridItemWidget({
    super.key,
    required this.model,
    required this.languageCode,
    required this.onTap,
  });

  final CategoryModel model;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildPreview(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              model.getNameByLanguage(languageCode),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    print('image: ${model.image}');
    if (model.image != null) {
      return Image.network(
        model.image!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildIconFallback(),
      );
    }
    return _buildIconFallback();
  }

  Widget _buildIconFallback() {
    return model.icon == null
        ? const Icon(Icons.category, color: Colors.grey)
        : Text(model.icon!, style: const TextStyle(fontSize: 30));
  }
}
