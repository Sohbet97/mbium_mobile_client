import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import '../widget/chats_empty_widget.dart';
import '../widget/chats_filter_widget.dart';
import '../widget/chats_notification_banner_widget.dart';
import '../widget/chats_promo_widget.dart';
import '../widget/chats_recommendation_widget.dart';
import '../widget/chats_search_widget.dart';
import '../widget/chats_tab_widget.dart';

import '../../../../generated/l10n.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
          const LoadCategoriesEvent(isRefresh: false),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    l10n.chats,
                    style: textStyles.s16w600clBlack.copyWith(fontSize: 20),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.info_outline,
                      size: 16, color: AppColors.textLightGrey),
                  const Spacer(),
                  const Icon(Icons.more_horiz,
                      color: AppColors.lightTextSecondary),
                ],
              ),
            ),
            const ChatsNotificationBannerWidget(),
            const ChatsTabWidget(),
            const SizedBox(height: 16),
            ChatsSearchWidget(controller: _searchController),
            const SizedBox(height: 12),
            const ChatsFilterWidget(),
            const SizedBox(height: 8),
            const ChatsEmptyWidget(),
            const ChatsPromoWidget(),
            const SizedBox(height: 20),
            const ChatsRecommendationWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}