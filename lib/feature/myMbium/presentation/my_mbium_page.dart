import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/mbium_menu_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/settings_banner_widget.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';
import 'package:mbium_mobile_client/feature/person/presentation/login_in_screen.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/person_litle_data_widget.dart';
import 'package:mbium_mobile_client/main.dart';

import '../../../generated/l10n.dart';

class MyMbiumPage extends StatelessWidget {
  const MyMbiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<PersonRepository>().preferences.isRegistered(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == true
              ? _MyMbiumDataPage()
              : const LoginInScreen();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _MyMbiumDataPage extends StatelessWidget {
  const _MyMbiumDataPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = S.of(context);

    final primaryColor = theme.colorScheme.primary;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.2),
                    primaryColor.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            const SizedBox(width: 5),

            _buildActionButton('assets/icons/support.svg', () {
              // TODO click to support
            }),
            const SizedBox(width: 5),

            _buildActionButton('assets/icons/scan.svg', () {
              // TODO click to scan
            }),
            const SizedBox(width: 5),

            _buildActionButton('assets/icons/settings.svg', () {
              Navigator.pushNamed(context, '/settings');
            }),
          ],
          title: const PersonLittleDataWidget(),
        ),
        const SliverToBoxAdapter(child: MbiumMenuWidget()),
        const SliverToBoxAdapter(child: SettingsBannerWidget()),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(color: theme.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.menin_sargytlarym,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isDarkTheme ? Colors.black : null,
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector _buildActionButton(String iconUrl, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsGeometry.only(right: 12),
          child: SvgIcon(iconName: iconUrl),
        ),
      );
}
