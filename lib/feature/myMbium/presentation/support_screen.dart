import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/chats/presentation/pages/chat_screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/support_faq_list_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/support_live_chat_button_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/support_search_bar_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/support_service_request_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/support_suggested_list_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  void _openScreen(String? message) {
    Navigator.pushNamed(
      context,
      '/chatScreen',
      arguments: ChatScreenArgs(initialMessage: message),
    );
  }

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
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SupportLiveChatButtonWidget(onTap: () => _openScreen(null)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              l10n.support_title,
              style: textStyles.s16w600clBlack.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 16),
            const SupportSearchBarWidget(),
            const SizedBox(height: 16),
            SupportServiceRequestWidget(onTap: () {}),
            const SizedBox(height: 24),
            SupportSuggestedListWidget(
              onTap: (String message) => _openScreen(message),
            ),
            const SizedBox(height: 24),
            const SupportFaqListWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
