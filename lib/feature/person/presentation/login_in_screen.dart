import 'package:flutter/material.dart';

class LoginInScreen extends StatefulWidget {
  const LoginInScreen({super.key});

  @override
  State<LoginInScreen> createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  @override
  Widget build(BuildContext context) {
    final logoUrl = 'assets/icons/logo.svg';
    return Center(child: Text('loginIN'));
  }
}
