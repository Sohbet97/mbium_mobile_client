import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class FavoriteItemWidget extends StatelessWidget {
  const FavoriteItemWidget({
    super.key,
    required this.product,
    this.size = 22,
    this.padding = const EdgeInsets.all(6),
    this.withBackground = false,
  });

  final ProductModel product;
  final double size;
  final EdgeInsetsGeometry padding;

  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoriteBloc, bool>((bloc) {
      final s = bloc.state;
      return s is FavoriteLoaded && s.isFavorite(product.id);
    });

    final icon = GestureDetector(
      onTap: () =>
          context.read<FavoriteBloc>().add(ToggleFavoriteProduct(product)),
      child: Padding(
        padding: padding,
        child: Icon(
          isFav ? Icons.star : Icons.star_border,
          size: size,
          color: isFav ? Colors.amber : AppColors.lightTextSecondary,
        ),
      ),
    );

    if (!withBackground) return icon;

    return GestureDetector(
      onTap: () =>
          context.read<FavoriteBloc>().add(ToggleFavoriteProduct(product)),
      child: Container(
        padding: padding,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFav ? Icons.star : Icons.star_border,
          size: size,
          color: isFav ? Colors.amber : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
