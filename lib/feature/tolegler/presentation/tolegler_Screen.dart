import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class ToleglerScreen extends StatefulWidget {
  const ToleglerScreen({super.key});

  @override
  State<ToleglerScreen> createState() => _ToleglerScreenState();
}

class _ToleglerScreenState extends State<ToleglerScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(appBar: AppBar(title: Text(localization.tolegler)));
  }
}
