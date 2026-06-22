import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailWidget extends StatelessWidget {
  const ShopDetailWidget({super.key, required this.model});
  final ShopDetailModel model;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(model.localizedName));
  }
}
