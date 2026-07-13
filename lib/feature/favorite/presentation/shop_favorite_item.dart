import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/shop_favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopFavoriteItemWidget extends StatelessWidget {
  const ShopFavoriteItemWidget({
    super.key,
    required this.shop,
    this.size = 22,
    this.color,
  });

  final ShopDetailModel shop;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<ShopFavoriteBloc, bool>((bloc) {
      final s = bloc.state;
      return s is ShopFavoriteLoaded && s.isFavorite(shop.id);
    });

    return GestureDetector(
      onTap: () =>
          context.read<ShopFavoriteBloc>().add(ToggleFavoriteShop(shop)),
      child: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        size: size,
        color: isFav ? Colors.red : (color ?? AppColors.lightTextPrimary),
      ),
    );
  }
}
