import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../generated/l10n.dart';
import 'otp_verified_screen.dart';
import 'widgets/phone_auth_widgets.dart';
import 'widgets/phone_number_widget.dart';

class LoginByPhoneScreen extends StatefulWidget {
  const LoginByPhoneScreen({super.key});

  @override
  State<LoginByPhoneScreen> createState() => _LoginByPhoneScreenState();
}

class _LoginByPhoneScreenState extends State<LoginByPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.TM, nsn: ''),
  );

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phoneNumber = _phoneController.value.international;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerifiedScreen(phoneNumber: phoneNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhoneAuthHeader(
              icon: Icons.phone_iphone_rounded,
              title: loc.telefon_arkaly_giris,
              subtitle: loc.telefon_arkaly_giris_desc,
            ),
            PhoneAuthSheet(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      loc.telefon_belgi,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PhoneNumberWidget(
                      controller: _phoneController,
                      hintText: loc.telefon_belgi,
                      validator: PhoneValidator.compose([
                        PhoneValidator.required(
                          context,
                          errorText: loc.telefon_belgi,
                        ),
                        PhoneValidator.validMobile(
                          context,
                          errorText: loc.telefon_belgi,
                        ),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      loc.ibermek_bilen_razylasyarsynyz,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthPrimaryButton(label: loc.dowam_et, onTap: _submit),
                    const SizedBox(height: 18),
                    AuthTrustBadge(text: loc.maglumat_gorag_astynda),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
