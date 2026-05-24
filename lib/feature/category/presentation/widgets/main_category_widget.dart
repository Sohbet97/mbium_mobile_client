import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

class MainCategoryWidget extends StatelessWidget {
  const MainCategoryWidget({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  });
  final CategoryModel model;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? isDark
              ? Colors.grey.shade800
              : AppColors.lightSurface
        : null;
    final style = TextStyle(
      fontSize: isSelected ? 15 : 14,
      fontWeight: isSelected ? FontWeight.bold : null,
    );
    final l = context.read<MainBloc>().state.languageCode;

    final name = model.getNameByLanguage(l);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(color: color),
        child: Row(
          children: [
            const SizedBox(width: 4),
            if (isSelected)
              Container(
                height: 30,
                width: 2,
                color: AppColors.primaryGreen,
                margin: const EdgeInsets.only(right: 5),
              ),

            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
