import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import 'widgets/phone_auth_widgets.dart';

class OtpVerifiedScreen extends StatefulWidget {
  const OtpVerifiedScreen({super.key, this.sessionId, this.phoneNumber});

  /// Backend session id for the email/password registration flow.
  final String? sessionId;

  /// Phone number entered on [LoginByPhoneScreen], shown to the user so
  /// they know where the code was sent.
  final String? phoneNumber;

  @override
  State<OtpVerifiedScreen> createState() => _OtpVerifiedScreenState();
}

class _OtpVerifiedScreenState extends State<OtpVerifiedScreen> {
  String _code = '';

  void _submit() {
    if (_code.length < 6) return;
    // TODO: wire up OTP verification once the API endpoints are available.
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
              icon: Icons.sms_outlined,
              title: loc.sms_tassyklama,
              subtitle: widget.phoneNumber != null
                  ? '${loc.kody_iberdik}\n${widget.phoneNumber}'
                  : loc.kody_iberdik,
            ),
            PhoneAuthSheet(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.phoneNumber != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(loc.belgini_uytget),
                      ),
                    ),
                  OtpCodeField(onChanged: (value) => setState(() => _code = value)),
                  const SizedBox(height: 28),
                  Center(
                    child: ResendCodeTimer(
                      label: loc.kody_gaytadan_ibermek,
                      onResend: () {
                        // TODO: trigger resend-code API call once available.
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthPrimaryButton(
                    label: loc.tassyklamak,
                    enabled: _code.length == 6,
                    onTap: _submit,
                  ),
                  const SizedBox(height: 18),
                  AuthTrustBadge(text: loc.maglumat_gorag_astynda),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
