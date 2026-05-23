import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

class ButtonWidget extends StatelessWidget {
  final String iconUrl;
  final String title;
  final VoidCallback onTap;
  const ButtonWidget({
    super.key,
    required this.iconUrl,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isDarkTheme ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(title, style: context.appTextStyles.s13w600clBlack),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SvgIcon(iconName: iconUrl, height: 20, width: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
