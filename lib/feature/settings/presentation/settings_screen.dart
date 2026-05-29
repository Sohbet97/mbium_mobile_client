import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/all_functions_screen.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

import '../../splash/bloc/main_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _shomLanguagePicker(BuildContext context) async {
    final localization = S.of(context);
    final currentLocale = context.read<MainBloc>().state.languageCode;
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                context.read<MainBloc>().add(
                  ChangeLanguage(languageCode: 'en'),
                );
                Navigator.pop(context);
              },
              leading: Text('🇺🇸', style: TextStyle(fontSize: 20)),
              title: Text(localization.english),
              trailing: currentLocale == 'en'
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
            ),
            ListTile(
              onTap: () {
                context.read<MainBloc>().add(
                  ChangeLanguage(languageCode: 'ru'),
                );
                Navigator.pop(context);
              },
              leading: Text('🇷🇺', style: TextStyle(fontSize: 20)),
              title: Text(localization.russkiy),
              trailing: currentLocale == 'ru'
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
            ),
            ListTile(
              onTap: () {
                context.read<MainBloc>().add(
                  ChangeLanguage(languageCode: 'tk'),
                );
                Navigator.pop(context);
              },
              leading: Text('🇹🇲', style: TextStyle(fontSize: 20)),
              title: Text(localization.turkmence),
              trailing: currentLocale == 'tk'
                  ? Icon(Icons.check, color: Colors.blue)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _clearCache(BuildContext context) {}

  void _onLogOut(BuildContext context) async {
    final result = await MyHelpers.showAlertDialog(
      context,
      S.of(context).log_out,
      S.of(context).log_out_desc,
      Icons.exit_to_app,
      AppColors.errorRed,
    );

    if (result == true) {
      context.read<PersonBloc>().add(LogOutEvent());
      MyHelpers.showMessage(
        S.of(context).ulgamdan_cykdynyz,
        AppColors.primaryGreen,
        context,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localization.settings)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildItem(localization.profil, () {
              Navigator.pushNamed(context, '/profil');
            }, null),
            const SizedBox(height: 10),

            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildItem(localization.addresses, () {
                    Navigator.pushNamed(context, '/addresses');
                  }, null),
                  _buildDivider(),
                  _buildItem(localization.currency, () {}, Text('TMT')),
                  _buildDivider(),
                  _buildItem(
                    localization.language,
                    () => _shomLanguagePicker(context),
                    const LanguageWidget(),
                  ),
                  _buildDivider(),
                  _buildItem(localization.notifications, () {
                    // TODO open notifications settings
                  }, null),
                  _buildDivider(),
                  _buildItem(localization.delete_user, () {
                    // TODO open notifications settings
                  }, null),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildItem(localization.version, () {}, const Text('1.0.0')),
                  _buildDivider(),
                  _buildItem(localization.ulanys_duzgunleri, () {}, null),
                  _buildDivider(),

                  _buildItem(
                    localization.kes_arassalamak,
                    () => _clearCache(context),
                    null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            _buildItem(localization.log_out, () => _onLogOut(context), null),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildItem(
    String title,
    VoidCallback onTap,
    Widget? trailing,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            (trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade300);
  }
}
