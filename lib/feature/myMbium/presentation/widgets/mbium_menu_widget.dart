import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

import '../../../../generated/l10n.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.ayratynlyklar,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(child: Icon(Icons.arrow_right)),
            ],
          ),
          const SizedBox(height: 11),

          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildItem(
                  '$mainUrl/favorite.svg',
                  localization.favorites,
                  () {},
                  null,
                ),

                _buildItem(
                  '$mainUrl/history.svg',
                  localization.history,
                  () {},
                  null,
                ),

                _buildItem(
                  '$mainUrl/abuna.svg',
                  localization.abuna,
                  () {},
                  null,
                ),

                _buildItem(
                  '$mainUrl/cupon.svg',
                  localization.kupons,
                  () {},
                  null,
                ),

                _buildItem(
                  '$mainUrl/toleg.svg',
                  localization.tolegler,
                  () {},
                  null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildItem(
    String url,
    String title,
    VoidCallback onTap,
    String? badgeLabel,
  ) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 75,
      child: Badge(
        alignment: AlignmentGeometry.topCenter,
        isLabelVisible: badgeLabel != null,
        child: Column(
          children: [
            SvgIcon(iconName: url),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
