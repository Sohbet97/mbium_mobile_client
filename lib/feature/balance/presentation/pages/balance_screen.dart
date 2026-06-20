import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/widgets/mbium_ballar_widget.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/widgets/reward_card.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/widgets/setting_tile.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/widgets/transaction_widget.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/widgets/video_reward_card.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.deepForest),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                /// Top Bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 20),

                /// Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        localization.balance,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: AppColors.secondaryGreen,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            localization.goralan,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// Balance Label
                Center(
                  child: Text(
                    localization.garashylyan_mukdar,
                    style: TextStyle(
                      color: AppColors.balanceTextGrey,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 11),

                /// Balance Amount
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "10",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.balanceTextGrey,
                        size: 32,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [MbiumBallarWidget()],
                ),

                /// Honey Banner
                const SizedBox(height: 29),

                /// Transactions Card
                TransactionWidget(),
                const SizedBox(height: 15),

                /// Rewards Card
                RewardCard(),
                const SizedBox(height: 15),

                /// Video Reward Card
                VideoRewardCard(),
                const SizedBox(height: 23),

                Text(
                  localization.sazlamalar,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 11),

                /// Settings Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    //horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondaryGreen),
                  ),
                  child: Column(
                    children: [
                      SettingTile(
                        icon: 'assets/icons/wallet_icon.svg',
                        title: localization.toleg_usullary,
                        onTap: () {},
                      ),
                      SettingTile(
                        icon: 'assets/icons/account_security.svg',
                        title: localization.shahsyyetini_tassyklamak,
                        onTap: () =>
                            Navigator.pushNamed(context, '/verifyAccount'),
                      ),
                      SettingTile(
                        icon: 'assets/icons/help.svg',
                        title: localization.komek_seslenme,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
