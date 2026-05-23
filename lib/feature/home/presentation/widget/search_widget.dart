import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

import '../../../../generated/l10n.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.controller,
    required this.onTapPhoto,
    required this.onTapAudio,
    required this.onTapAi,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onTapPhoto;
  final VoidCallback onTapAudio;
  final VoidCallback onTapAi;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(
          8,
        ), // Сделал чуть мягче углы (было 4)
        color: !isDarkTheme ? Colors.white : Colors.grey.shade800,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Выравнивание элементов строки по центру
        children: [
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTapPhoto,
            child: const SvgIcon(iconName: 'assets/icons/camera.svg'),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: S.of(context).search,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          GestureDetector(
            onTap: onTapAudio,
            child: const SvgIcon(iconName: 'assets/icons/microphone.svg'),
          ),
          const SizedBox(width: 8),

          GestureDetector(
            onTap: onSubmit,
            child: Container(
              height: 37,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [color.withOpacity(0.85), color],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: SvgIcon(
                iconName: 'assets/icons/search.svg',
                color: Colors.grey.shade100,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
