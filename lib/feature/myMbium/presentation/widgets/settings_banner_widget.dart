import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';
import 'package:mbium_mobile_client/feature/person/presentation/login_in_screen.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class SettingsBannerWidget extends StatelessWidget {
  const SettingsBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return FutureBuilder(
      future: context.read<PersonRepository>().preferences.isGostUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data) {
            return Container(
              margin: const EdgeInsets.only(
                top: 1,
                bottom: 5,
                left: 10,
                right: 10,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.2),
                    primaryColor.withOpacity(0.4),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).ai_agent_mugt_barla_desc,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SvgIcon(
                    iconName: 'assets/icons/search.svg',
                    color: primaryColor,
                  ),

                  const SizedBox(width: 8),

                  GestureDetector(
                    //_showModal(context),
                    child: Icon(Icons.arrow_right, color: Colors.grey.shade800),
                  ),
                ],
              ),
            );
          }
        }
        return SizedBox.shrink();
      },
    );
  }

  void _showModal(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => LoginInScreen(isModal: true),
    );
  }
}
