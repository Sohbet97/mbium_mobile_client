import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

class ShopDetailCategoriesWidget extends StatelessWidget {
  const ShopDetailCategoriesWidget({super.key});

  IconData _getCategoryIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('elektron') || n.contains('tech')) return Icons.devices_outlined;
    if (n.contains('egin') || n.contains('fashion') || n.contains('geýim')) return Icons.checkroom_outlined;
    if (n.contains('öý') || n.contains('home')) return Icons.home_outlined;
    if (n.contains('gözellik') || n.contains('beauty')) return Icons.face_outlined;
    if (n.contains('awtomobil') || n.contains('auto')) return Icons.directions_car_outlined;
    if (n.contains('sport')) return Icons.sports_outlined;
    if (n.contains('kitap') || n.contains('book')) return Icons.book_outlined;
    if (n.contains('oýun') || n.contains('toy')) return Icons.toys_outlined;
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is! LoadCategoriesSuccess) return const SizedBox.shrink();
        final categories = state.categories;
        if (categories.isEmpty) return const SizedBox.shrink();

        return Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kategoriýalar bölümi', style: textStyles.s13w600clBlack),
              const SizedBox(height: 14),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    final name = cat.getNameByLanguage(languageCode);
                    return Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.lightBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(name),
                            color: AppColors.primaryGreen,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.lightTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}