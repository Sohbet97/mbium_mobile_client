import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class PersonAdvancedWidget extends StatelessWidget {
  const PersonAdvancedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.haryt_gozlegindaki_ileri_tutmalar,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/heart.svg',
                    width: 40, height: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.harytlar_ucin_shahsy_hodurlemeleri_alyn,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(l10n.gozleg_tejribani_gowulandyrmak,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}