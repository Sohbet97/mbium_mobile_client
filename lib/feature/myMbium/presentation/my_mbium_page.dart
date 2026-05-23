import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/feature/person/presentation/login_in_screen.dart';

class MyMbiumPage extends StatefulWidget {
  const MyMbiumPage({super.key});

  @override
  State<MyMbiumPage> createState() => _MyMbiumPageState();
}

class _MyMbiumPageState extends State<MyMbiumPage> {
  @override
  void initState() {
    super.initState();
    context.read<PersonBloc>().add(IsRegisteredEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        final registered = state.isRegistered;
        return registered ? Container() : LoginInScreen();
      },
    );
  }
}
