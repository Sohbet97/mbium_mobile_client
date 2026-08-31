import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/profile_change_password_dialog.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/profile_edit_field_dialog.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/profile_info_row_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProfileInfoCardWidget extends StatefulWidget {
  final String fullName;
  final String email;

  const ProfileInfoCardWidget({
    super.key,
    required this.fullName,
    required this.email,
  });

  @override
  State<ProfileInfoCardWidget> createState() => _ProfileInfoCardWidgetState();
}

class _ProfileInfoCardWidgetState extends State<ProfileInfoCardWidget> {
  late String _fullName = widget.fullName;
  late String _email = widget.email;

  static String _maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 1) return email;
    final visible = email.substring(0, atIndex > 4 ? 3 : 1);
    return '$visible****${email.substring(atIndex)}';
  }

  Future<void> _editFullName() async {
    final l10n = S.of(context);
    final result = await showProfileEditFieldDialog(
      context,
      title: l10n.doly_ady,
      initialValue: _fullName,
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _fullName = result);
    }
  }

  Future<void> _editEmail() async {
    final l10n = S.of(context);
    final result = await showProfileEditFieldDialog(
      context,
      title: l10n.epocta_adres,
      initialValue: _email,
      keyboardType: TextInputType.emailAddress,
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _email = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          ProfileInfoRowWidget(
            label: l10n.doly_ady,
            value: _fullName.isNotEmpty ? _fullName : '—',
            onTap: _editFullName,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ProfileInfoRowWidget(
            label: l10n.epocta_adres,
            value: _maskEmail(_email),
            onTap: _editEmail,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ProfileInfoRowWidget(
            label: l10n.telefon_belgisi,
            value: l10n.doldurulmandyr,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ProfileInfoRowWidget(
            label: l10n.paroly_uytgetmek,
            value: '',
            onTap: () => showProfileChangePasswordDialog(context),
          ),
        ],
      ),
    );
  }
}