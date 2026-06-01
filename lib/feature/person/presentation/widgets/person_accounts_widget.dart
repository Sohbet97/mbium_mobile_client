import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class PersonAccountsWidget extends StatelessWidget {
  const PersonAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.baglanan_hasaplar,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(l10n.baglanan_hasaplar_desc,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.lightTextSecondary)),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/google.svg',
                          width: 22, height: 22),
                      const SizedBox(width: 10),
                      const Text('Google',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.baglanan,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.bonusBannerTextGreen)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined,
                          color: AppColors.primaryGreen, size: 22),
                      const SizedBox(width: 10),
                      Text(l10n.telefon_belgi,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.baglanmady,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}