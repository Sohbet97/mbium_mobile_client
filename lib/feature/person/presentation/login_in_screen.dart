import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/button_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../generated/l10n.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key, this.isModal});
  final bool? isModal;
  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  @override
  Widget build(BuildContext context) {
    final logoUrl = 'assets/images/logo.png';
    final logoImageUrl = 'assets/images/login_top_image.png';
    final localization = S.of(context);
    return Scaffold(
      body: BlocConsumer<PersonBloc, PersonState>(
        listener: (context, state) {
          if (state.isGostUser == true) {
            context.read<MainBloc>().add(SetNavigationPageEvent(index: 4));
          }
        },
        builder: (context, state) {
          return Column(
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
                      localization.turkmenistanda_oyden_cykman_sowda_et,
                      style: context.appTextStyles.s14w400clWhite,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 7),
                    Text(
                      localization.sargyt_goraglylygy,
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
                  title: localization.google_dowan_et,
                  onTap: () {},
                ),
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ButtonWidget(
                  iconUrl: 'assets/icons/call.svg',
                  title: localization.telefon_bilen_dowam_et,
                  onTap: () {},
                ),
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ButtonWidget(
                  iconUrl: 'assets/icons/mail.svg',
                  title: localization.email_bilen_dowam_et,
                  onTap: () {},
                ),
              ),
              SizedBox(height: 29),
              GestureDetector(
                onTap: () {
                  context.read<PersonBloc>().add(RegisterWithGostEvent());
                  if (widget.isModal == true) {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  localization.myhma_hokmunde,
                  style: context.appTextStyles.s13w600clBlack.copyWith(
                    color: AppColors.textLightGrey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
