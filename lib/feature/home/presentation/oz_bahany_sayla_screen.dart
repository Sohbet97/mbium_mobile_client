import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/oz_bahany_header_widget.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/oz_bahany_buttons_widget.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/oz_bahany_form_widget.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/oz_bahany_recently_widget.dart';
import '../../../generated/l10n.dart';

class OzBahanySaylaScreen extends StatefulWidget {
  const OzBahanySaylaScreen({super.key});

  @override
  State<OzBahanySaylaScreen> createState() => _OzBahanySaylaScreenState();
}

class _OzBahanySaylaScreenState extends State<OzBahanySaylaScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecentlyViewedBloc>().add(LoadRecentlyViewed());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.navWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bonusBannerTextGreen,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ÖBS',
                style: TextStyle(
                  color: AppColors.navWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.oz_bahany_appbar_title,
                style: textStyles.s13w600clBlack.copyWith(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OzBahanyHeaderWidget(),
            const SizedBox(height: 16),
            const OzBahanyButtonsWidget(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward,
                   color: AppColors.bonusBannerTextGreen, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    l10n.obs_barada_has_ginisleyin,
                    style: const TextStyle(
                      color: AppColors.bonusBannerTextGreen,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.bonusBannerTextGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const OzBahanyFormWidget(),
            const SizedBox(height: 24),
            const OzBahanyRecentlyWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}