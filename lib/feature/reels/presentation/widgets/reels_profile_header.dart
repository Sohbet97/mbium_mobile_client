import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_menu_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'package:mbium_mobile_client/main.dart';

class ReelsProfileHeader extends StatelessWidget {
  final ReelsModel reel;

  /// Defaults to opening [ShopDetailScreen] — pass a different callback
  /// (e.g. from a shop-scoped reels screen) to override where tapping the
  /// shop name/avatar leads.
  final VoidCallback? onOpenShop;
  final VoidCallback? onOpenGiftSheet;

  const ReelsProfileHeader({
    super.key,
    required this.reel,
    this.onOpenShop,
    this.onOpenGiftSheet,
  });

  void _showReelsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black45,
      isScrollControlled: true,
      builder: (context) {
        return ReelsMenuWidget();
      },
    );
  }

  void _openShop(BuildContext context) {
    if (onOpenShop != null) {
      onOpenShop!();
      return;
    }
    Navigator.pushNamed(
      context,
      '/shopDetail',
      arguments: reel.shop.toShopModel(),
    );
  }

  final s10w500 = const TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    final logo = reel.shop.logo;
    return Row(
      children: [
        GestureDetector(
          onTap: () => _openShop(context),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white70,
            backgroundImage: logo != null && logo.isNotEmpty
                ? NetworkImage(myMediaUrl + logo)
                : null,
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => _openShop(context),
          child: Text(reel.shop.name, style: s10w500.copyWith(fontSize: 14)),
        ),
        const SizedBox(width: 5),

        _buildGiftButton(context),

        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            _showReelsMenu(context);
          },
          child: Icon(Icons.more_horiz, color: Colors.white, size: 24),
        ),
      ],
    );
  }

  Widget _buildGiftButton(BuildContext context) {
    return InkWell(
      onTap: onOpenGiftSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondaryGreen),
        ),
        child: Row(
          children: [
            const Icon(Icons.card_giftcard, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(S.of(context).sowgat_ber, style: s10w500),
          ],
        ),
      ),
    );
  }
}
