import 'package:flutter/material.dart';

class OtpVerifiedScreen extends StatefulWidget {
  const OtpVerifiedScreen({super.key, required this.sessionId});
  final String sessionId;
  @override
  State<OtpVerifiedScreen> createState() => _OtpVerifiedScreenState();
}

class _OtpVerifiedScreenState extends State<OtpVerifiedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('verify')));
  }
}
