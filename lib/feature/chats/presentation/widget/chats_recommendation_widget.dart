import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import '../../../../generated/l10n.dart';

class ChatsRecommendationWidget extends StatefulWidget {
  const ChatsRecommendationWidget({super.key});

  @override
  State<ChatsRecommendationWidget> createState() =>
      _ChatsRecommendationWidgetState();
}

class _ChatsRecommendationWidgetState
    extends State<ChatsRecommendationWidget> {
  int _selectedIndex = 0;
  bool _expanded = false;
  static const int _visibleCount = 3;

  String _getCategoryName(CategoryModel category) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'ru':
        return category.nameRu.isNotEmpty ? category.nameRu : category.name;
      case 'en':
        return category.nameEng.isNotEmpty ? category.nameEng : category.name;
      default:
        return category.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.siz_ucin_maslahat,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.aiTextBlack,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Kategori tabs - search ikonu + underline stil + expand ok
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is! LoadCategoriesSuccess) return const SizedBox.shrink();
            final categories = state.categories;
            final showExpand = categories.length > _visibleCount;
            final displayList = _expanded
                ? categories
                : categories.take(_visibleCount).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      size: 18, color: AppColors.lightTextSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: List.generate(displayList.length, (i) {
                        final isSelected = _selectedIndex == i;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedIndex = i),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getCategoryName(displayList[i]),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    height: 2,
                                    width: 40,
                                    color: AppColors.primaryGreen,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  if (showExpand)
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // Ürün grid - 2 sütun
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: 4,
            itemBuilder: (context, i) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://picsum.photos/seed/${i + 20}/300/300',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: AppColors.textLightGrey),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}