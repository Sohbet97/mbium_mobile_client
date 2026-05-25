import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ChatsTabWidget extends StatefulWidget {
  final ValueChanged<int>? onTabChanged;

  const ChatsTabWidget({super.key, this.onTabChanged});

  @override
  State<ChatsTabWidget> createState() => _ChatsTabWidgetState();
}

class _ChatsTabWidgetState extends State<ChatsTabWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final tabs = [
      {'icon': Icons.receipt_long_outlined, 'label': l10n.sargytlar},
      {'icon': Icons.notifications_outlined, 'label': l10n.duydurys},
      {'icon': Icons.more_horiz_outlined, 'label': l10n.basga},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final isSelected = _selectedIndex == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = i);
              widget.onTabChanged?.call(i);
            },
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      tabs[i]['icon'] as IconData,
                      size: 28,
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.lightTextSecondary,
                    ),
                    if (i == 1)
                      Positioned(
                        top: -4,
                        right: -6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.errorRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '10',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tabs[i]['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}