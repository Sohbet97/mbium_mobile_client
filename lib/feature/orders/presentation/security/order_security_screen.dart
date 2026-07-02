import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/pages/gorag_main_page.dart';
import '../../../../generated/l10n.dart';

class OrderSecurityScreen extends StatefulWidget {
  const OrderSecurityScreen({super.key});

  @override
  State<OrderSecurityScreen> createState() => _OrderSecurityScreenState();
}

class _OrderSecurityScreenState extends State<OrderSecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.gorag, style: textStyles.s16w600clBlack),
        centerTitle: true,
      ),
      body: const GoragMainPage(),
    );
  }
}