import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_menu_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReelsProfileHeader extends StatelessWidget {
  final ReelsModel reel;
  ReelsProfileHeader({super.key, required this.reel});
  final String _currentUserName = 'Kadyr Otuzow';

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

  final s10w500 = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white70,
          // backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 5),
        Text(_currentUserName, style: s10w500.copyWith(fontSize: 14)),
        const SizedBox(width: 5),

        _buildGiftButton(context),
        if (reel.isLive)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: _buildLiveTag(context),
          ),
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
    return Container(
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
    );
  }

  Widget _buildLiveTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(S.of(context).live, style: s10w500),
        ],
      ),
    );
  }
}
