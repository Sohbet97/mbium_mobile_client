import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:mbium_mobile_client/feature/top_products/presentation/widget/category_bottom_sheet_widget.dart';
import '../../../../generated/l10n.dart';

class TopProductsHeaderWidget extends StatefulWidget {
  const TopProductsHeaderWidget({super.key});

  @override
  State<TopProductsHeaderWidget> createState() =>
      _TopProductsHeaderWidgetState();
}

class _TopProductsHeaderWidgetState extends State<TopProductsHeaderWidget> {
  CategoryModel? _selectedCategory;

  void _openCategorySheet(
      BuildContext context, List<CategoryModel> categories) async {
    final result = await showModalBottomSheet<CategoryModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryBottomSheet(
        categories: categories,
        selectedCategory: _selectedCategory,
      ),
    );

    if (result is CategoryModel) {
      setState(() => _selectedCategory = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final categories = state is LoadCategoriesSuccess
            ? state.categories
            : <CategoryModel>[];

        final buttonLabel = _selectedCategory != null
            ? _selectedCategory!.getNameByLanguage(languageCode)
            : l10n.kategoriyany_saylan;

        return Container(
          width: double.infinity,
          color: AppColors.primaryGreen,
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.navWhite, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    l10n.turkmenistanda_in_gowysy,
                    style: textStyles.s16w600clBlack.copyWith(
                      color: AppColors.navWhite,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.search,
                    color: AppColors.secondaryGreen,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => _openCategorySheet(context, categories),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.navWhite.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.navWhite.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonLabel,
                        style: const TextStyle(
                          color: AppColors.navWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.navWhite, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}