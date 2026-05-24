import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/button_widget.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  @override
  Widget build(BuildContext context) {
    final logoUrl = 'assets/images/logo.png';
    final logoImageUrl = 'assets/images/login_top_image.png';
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff187443), Color(0xff5FA67E)],
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset(logoUrl),
                SizedBox(height: 14),
                Text(
                  'Türkmenistanyň ähli ýerinden öýden çykman söwda ediň.',
                  style: context.appTextStyles.s14w400clWhite,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 7),
                Text(
                  'Sargyt goraglylygy we \n uly arzanladyşlar',
                  style: context.appTextStyles.s20w700clWhite,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 11),
              ],
            ),
          ),
          Image.asset(logoImageUrl),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ButtonWidget(
              iconUrl: 'assets/icons/google.svg',
              title: 'Google bilen dowam et',
              onTap: () {},
            ),
          ),
          SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ButtonWidget(
              iconUrl: 'assets/icons/call.svg',
              title: 'Telefon belgi arkaly dowam et',
              onTap: () {},
            ),
          ),
          SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ButtonWidget(
              iconUrl: 'assets/icons/mail.svg',
              title: 'Elektron poçta arkaly dowam et',
              onTap: () {},
            ),
          ),
          SizedBox(height: 29),
          Text(
            'Myhman hökmünde dowam et',
            style: context.appTextStyles.s13w600clBlack.copyWith(
              color: AppColors.textLightGrey,
            ),
          ),
        ],
      ),
    );
  }
}
