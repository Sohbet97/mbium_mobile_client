import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/rfq_search_widget.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/rfq_details_widget.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/rfq_image_widget.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/rfq_quantity_widget.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/widget/rfq_checkboxes_widget.dart';
import '../../../generated/l10n.dart';

class OzBahanRfqScreen extends StatefulWidget {
  const OzBahanRfqScreen({super.key});

  @override
  State<OzBahanRfqScreen> createState() => _OzBahanRfqScreenState();
}

class _OzBahanRfqScreenState extends State<OzBahanRfqScreen> {
  final _searchController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _detailsController.dispose();
    super.dispose();
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RfqSearchWidget(controller: _searchController),
            const SizedBox(height: 20),

            RfqDetailsWidget(controller: _detailsController),
            const SizedBox(height: 16),

            const RfqImageWidget(),
            const SizedBox(height: 20),

            const RfqQuantityWidget(),
            const SizedBox(height: 20),

            const RfqCheckboxesWidget(),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.navWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.ugrat,
                  style: textStyles.s16w600clBlack.copyWith(
                    color: AppColors.navWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}