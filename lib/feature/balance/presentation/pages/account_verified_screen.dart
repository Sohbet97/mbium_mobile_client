import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/widgets/verification_button.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class AccountVerifiedScreen extends StatefulWidget {
  const AccountVerifiedScreen({super.key});

  @override
  State<AccountVerifiedScreen> createState() => _AccountVerifiedScreenState();
}

class _AccountVerifiedScreenState extends State<AccountVerifiedScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.deepForest,
      body: SafeArea(
        child: Padding(
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
                    Icon(
                      Icons.check_circle,
                      color: Color(0xff4B9976),
                      size: 60,
                    ),
                    SizedBox(height: 17),
                    Text(
                      localization.shahsyyetiniz_tassyklandy,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // verification
              const SizedBox(height: 62),
              Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 17, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.tassyklama_tapgyrlary,
                      style: const TextStyle(
                        color: AppColors.balanceTextGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.secondaryGreen,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          localization.shahsy_maglumatlaryny_iber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.secondaryGreen,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          localization.maglumatlar_barlanyar,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.secondaryGreen,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          localization.shahsyyetiniz_tassyklandy,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //button
              Spacer(),
              VerificationButton(title: 'Dowam et', onTap: () {}),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
