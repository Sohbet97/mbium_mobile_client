import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';

class CategoryBreadcrumbWidget extends StatelessWidget {
  const CategoryBreadcrumbWidget({
    super.key,
    required this.path,
    required this.languageCode,
    required this.onSegmentTap,
  });

  final List<CategoryModel> path;
  final String languageCode;
  final ValueChanged<int> onSegmentTap;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: path.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Center(
            child: Text('/', style: TextStyle(color: theme.hintColor)),
          ),
        ),
        itemBuilder: (context, index) {
          final isLast = index == path.length - 1;
          final category = path[index];
          return GestureDetector(
            onTap: isLast ? null : () => onSegmentTap(index),
            child: Center(
              child: Text(
                category.getNameByLanguage(languageCode),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                  color: isLast
                      ? theme.textTheme.bodyLarge?.color
                      : theme.hintColor,
                  decoration: isLast ? null : TextDecoration.underline,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
