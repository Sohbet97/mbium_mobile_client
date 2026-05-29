import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class AiPodpiskaScreen extends StatefulWidget {
  const AiPodpiskaScreen({super.key});

  @override
  State<AiPodpiskaScreen> createState() => _AiPodpiskaScreenState();
}

class _AiPodpiskaScreenState extends State<AiPodpiskaScreen> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(appBar: AppBar(title: Text(localization.podpiska)));
  }
}
