import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/person_header_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/person_info_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/person_accounts_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/person_advanced_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/person_trade_widget.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Meniň profilim', style: textStyles.s16w600clBlack),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonHeaderWidget(),
            SizedBox(height: 12),
            PersonInfoWidget(),
            SizedBox(height: 12),
            PersonAccountsWidget(),
            SizedBox(height: 12),
            PersonAdvancedWidget(),
            SizedBox(height: 12),
            PersonTradeWidget(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}