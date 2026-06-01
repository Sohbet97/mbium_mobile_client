import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class RfqTestimonialWidget extends StatelessWidget {
  const RfqTestimonialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryGreen,
            AppColors.primaryGreen,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Alıntı metni
          Text(
            l10n.rfq_testimonial_text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.navWhite,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.navBarGrey,
            child: const Icon(Icons.person,
                color: AppColors.lightTextSecondary, size: 28),
          ),
          const SizedBox(height: 10),

          // İsim
          const Text(
            'Kian Golzari',
            style: TextStyle(
              color: AppColors.navWhite,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Unvan
          Text(
            l10n.rfq_testimonial_title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.navWhite.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.navWhite,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.navWhite.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}