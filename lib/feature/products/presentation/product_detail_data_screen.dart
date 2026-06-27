import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_images_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../generated/l10n.dart';
import '../extensions/product_extensions.dart';

class ProductDetailDataScreen extends StatelessWidget {
  const ProductDetailDataScreen({
    super.key,
    required this.model,
    required this.litleProductModel,
  });
  final ProductDetailModel model;
  final ProductModel litleProductModel;
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final lang = AppLanguage.fromCode(
      context.read<MainBloc>().state.languageCode,
    );
    final name = model.nameByLang(lang);
    print(model.spinMedia.length);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(children: [ProductDetailImagesWidget(product: model)]),
        ),
      ),
    );
  }
}
