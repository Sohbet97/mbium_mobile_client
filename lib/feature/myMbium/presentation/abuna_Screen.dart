import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class AbunaScreen extends StatefulWidget {
  const AbunaScreen({super.key});

  @override
  State<AbunaScreen> createState() => _AbunaScreenState();
}

class _AbunaScreenState extends State<AbunaScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(appBar: AppBar(title: Text(localization.abuna)));
  }
}
