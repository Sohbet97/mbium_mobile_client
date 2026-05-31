import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class SatuwLiderleriTabWidget extends StatefulWidget {
  const SatuwLiderleriTabWidget({super.key});

  @override
  State<SatuwLiderleriTabWidget> createState() =>
      _SatuwLiderleriTabWidgetState();
}

class _SatuwLiderleriTabWidgetState extends State<SatuwLiderleriTabWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Center(child: Text('liderler'));
  }
}
