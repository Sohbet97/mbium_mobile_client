import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double height;
  final double width;

  const SvgIcon({
    super.key,
    required this.iconName,
    this.color,
    this.height = 24,
    this.width = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SvgPicture.asset(
      iconName,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
        color ?? theme.colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
