import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          return Text('person data');
        }

        if (isGost) {
          return ListTile(
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
        return SizedBox.shrink();
      },
    );
  }
}
