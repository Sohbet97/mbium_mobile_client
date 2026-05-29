import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key, required this.shopModel});
  final ShopModel shopModel;
  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.shopModel.localizedName)),
      body: Center(
        child: Text('Shop details for ${widget.shopModel.localizedName}'),
      ),
    );
  }
}
  