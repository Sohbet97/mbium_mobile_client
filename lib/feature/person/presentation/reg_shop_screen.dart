import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/custom_text_field.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/phone_number_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/reg_shop_button.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../generated/l10n.dart';

class RegShopScreen extends StatefulWidget {
  const RegShopScreen({super.key});

  @override
  State<RegShopScreen> createState() => _RegShopScreenState();
}

class _RegShopScreenState extends State<RegShopScreen> {
  final phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.TM, nsn: ''),
  );
  final textController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoImageUrl = 'assets/images/login_top_image.png';
    final localization = S.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<PersonBloc, PersonState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
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
                      Text(
                        localization.mbium_satys_bilen_biznes,
                        style: context.appTextStyles.s20w700clWhite,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 20),
                          Text(
                            localization.tutus_yurt_boyunca_alyjylar,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 20),
                          Text(
                            localization.caksiz_osush_ucin,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            localization.satuw_komisiyasy,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 20),
                          Text(
                            localization.degisli_hunarmenlerden_maslahatlar,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Image.asset(logoImageUrl),

                SizedBox(height: 20),
                Text(
                  localization.satyjy_hasabyny_doredin,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                Form(
                  key: _globalKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        PhoneNumberWidget(
                          hintText: localization.telefon_belgi,
                          controller: phoneController,
                          validator: PhoneValidator.compose([
                            PhoneValidator.required(
                              context,
                              errorText: localization.telefon_belgi,
                            ),
                            PhoneValidator.validMobile(
                              context,
                              errorText: localization.telefon_belgi,
                            ),
                          ]),
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: textController,
                          hintText: localization.karhananyn_dukanyn_ady,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return localization.karhananyn_dukanyn_ady;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          localization.ibermek_bilen_razylasyarsynyz,
                          style: context.appTextStyles.s14w400clWhite.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 11),
                        RegShopButton(
                          title: localization.dowam_et,
                          onTap: () {
                            if (_globalKey.currentState!.validate()) {
                              // TODO click to continue
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localization.sorag_bar_bolsa,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/chats');
                      },
                      child: Text(
                        localization.goni_efir,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).textTheme.labelSmall?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
