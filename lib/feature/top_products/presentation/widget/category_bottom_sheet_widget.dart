import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import '../../../../generated/l10n.dart';

class CategoryBottomSheet extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;

  const CategoryBottomSheet({
    super.key,
    required this.categories,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 8,
          right: 8,
          bottom: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            children: [
                
              Center(
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(l10n.categories, style: textStyles.s16w600clBlack),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          color: AppColors.lightTextSecondary, size: 22),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return _buildItemExpansion(
                      context,
                      item,
                      languageCode,
                      (model) => Navigator.pop(context, model),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionTile _buildItemExpansion(
    BuildContext context,
    CategoryModel model,
    String languageCode,
    ValueChanged<CategoryModel> onInitTap,
  ) {
    return ExpansionTile(
      title: Text(model.getNameByLanguage(languageCode)),
      onExpansionChanged: (isExpanded) {
        if (model.children.isEmpty) {
          onInitTap(model);
        }
      },
      children: model.children
          .map((item) => _buildItemExpansion(
                context,
                item,
                languageCode,
                onInitTap,
              ))
          .toList(),
    );
  }
}