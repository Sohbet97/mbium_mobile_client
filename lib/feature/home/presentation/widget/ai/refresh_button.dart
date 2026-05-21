import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgIcon(
          iconName: 'assets/icons/history_refresh_icon.svg',
          color: AppColors.aiTextBlack,
        ),
      ),
    );
  }
}
