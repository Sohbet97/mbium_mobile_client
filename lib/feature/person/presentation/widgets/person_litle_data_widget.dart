import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';

import '../../../../generated/l10n.dart';

class PersonLittleDataWidget extends StatefulWidget {
  const PersonLittleDataWidget({super.key});

  @override
  State<PersonLittleDataWidget> createState() => _PersonLittleDataWidgetState();
}

class _PersonLittleDataWidgetState extends State<PersonLittleDataWidget> {
  @override
  void initState() {
    super.initState();
    context.read<PersonBloc>().add(IsRegisteredEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        final person = state.personModel;
        final isGost = state.isGostUser;

        if (person != null) {
          final fullName = [
            person.name,
            person.surname,
          ].where((part) => part != null && part.isNotEmpty).join(' ');

          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/profil');
            },
            contentPadding: EdgeInsets.zero,
            leading: person.avatar != null
                ? CircleAvatar(
                    radius: 19,
                    backgroundImage: NetworkImage(person.avatar!),
                  )
                : SvgIcon(
                    iconName: 'assets/icons/person.svg',
                    height: 38,
                    width: 38,
                  ),
            title: Text(
              fullName.isNotEmpty ? fullName : person.email,
              maxLines: 1,
            ),
            subtitle: BlocBuilder<CoinBloc, CoinState>(
              builder: (context, coinState) {
                if (coinState is CoinLoading) {
                  return const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if (coinState is CoinLoaded) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/coin_image.png',
                        height: 18,
                        width: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${coinState.coin.balance}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }

        if (isGost) {
          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/loginIn');
            },
            contentPadding: EdgeInsets.zero,
            leading: SvgIcon(
              iconName: 'assets/icons/person.svg',
              height: 38,
              width: 38,
            ),
            title: Text(localization.myhman),
            subtitle: Text(
              localization.myhman_desc,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
