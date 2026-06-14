import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/main.dart';

import '../../../../generated/l10n.dart';
import '../../../favorite/bloc/favorite_bloc.dart';

class MbiumMenuWidget extends StatelessWidget {
  const MbiumMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mainUrl = 'assets/icons';
    final color = Theme.of(context).cardColor;
    final localization = S.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(color: color),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/allFunctions');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.ayratynlyklar,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? null : Colors.black,
                  ),
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
          const SizedBox(height: 11),

          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                    final favoriteCount = state is FavoriteLoaded
                        ? state.favorites.length
                        : 0;
                    return _buildItem(
                      '$mainUrl/favorite.svg',
                      localization.favorites,
                      () {
                        Navigator.pushNamed(context, '/favorite');
                      },
                      favoriteCount > 0 ? favoriteCount.toString() : null,
                    );
                  },
                ),

                BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
                  builder: (context, state) {
                    final count = state is RecentlyViewedLoaded
                        ? state.products.length
                        : 0;
                    return _buildItem(
                      '$mainUrl/history.svg',
                      localization.history,
                      () {
                        Navigator.pushNamed(context, '/review');
                      },
                      count > 0 ? count.toString() : null,
                    );
                  },
                ),

                _buildItem('$mainUrl/abuna.svg', localization.hasabym, () {
                  Navigator.pushNamed(context, '/hasabym');
                }, null),

                _buildItem('$mainUrl/abuna.svg', localization.abuna, () {
                  Navigator.pushNamed(context, '/abuna');
                }, null),

                _buildItem('$mainUrl/cupon.svg', localization.kupons, () {
                  Navigator.pushNamed(context, '/cupons');
                }, null),

                _buildItem('$mainUrl/toleg.svg', localization.tolegler, () {
                  Navigator.pushNamed(context, '/tolegler');
                }, null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    String url,
    String title,
    VoidCallback onTap,
    String? badgeLabel,
  ) {
    final bool hasBadge = badgeLabel != null && badgeLabel.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // Мягкий радиус эффекта нажатия
      splashColor: Colors.black.withOpacity(0.04),
      highlightColor: Colors.black.withOpacity(0.02),
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Обертываем только иконку, чтобы бадж не ломал верстку текста
            Badge(
              isLabelVisible: hasBadge,
              label: hasBadge
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      child: Text(
                        badgeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                          height: 1.1, // Центрирование текста по вертикали
                        ),
                      ),
                    )
                  : null,
              // Смещаем бадж на край иконки (настраивайте под размер вашей SvgIcon)
              largeSize: 16,
              offset: const Offset(6, -4),
              backgroundColor: const Color(
                0xFFFF3B30,
              ), // Дорогой системный красный (iOS style)
              child: Container(
                padding: const EdgeInsets.all(
                  8,
                ), // Легкая подложка для иконки, если нужно
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF8F9FA,
                  ), // Мягкий трендовый фон для самой иконки
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgIcon(iconName: url),
              ),
            ),

            const SizedBox(height: 6),

            // 2. Спокойный читаемый текст
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(
                  0xFF1A1A1A,
                ), // Мягкий черный вместо контрастного Colors.black
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
