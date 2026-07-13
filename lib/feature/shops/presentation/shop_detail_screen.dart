import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/widgets/my_error_widget.dart';
import 'package:mbium_mobile_client/feature/shops/bloc/shop_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_widget.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key, required this.shopModel});
  final ShopModel shopModel;
  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.shopModel.id != null) {
      context.read<ShopBloc>().add(
        GetShopDetailDataEvent(shopId: widget.shopModel.id!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ShopBloc, ShopState>(
          buildWhen: (previous, current) =>
              current is GetDetailShopDataError ||
              current is GetDetailShopDataProgress ||
              current is GetDetailShopDataSuccess,
          builder: (context, state) {
            switch (state) {
              case GetDetailShopDataProgress():
                return const Center(child: CircularProgressIndicator());
              case GetDetailShopDataSuccess():
                return ShopDetailWidget(model: state.response);
              case GetDetailShopDataError():
                return MyErrorWidget(
                  message: state.message,
                  onReload: () {
                    context.read<ShopBloc>().add(
                      GetShopDetailDataEvent(shopId: widget.shopModel.id ?? 0),
                    );
                  },
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}