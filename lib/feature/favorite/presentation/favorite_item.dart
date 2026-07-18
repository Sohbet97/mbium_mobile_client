import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

import '../../../generated/l10n.dart';

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

  void _onTap(BuildContext context) {
    final personState = context.read<PersonBloc>().state;
    final isLoggedIn =
        personState.isRegistered &&
        !personState.isGostUser &&
        personState.personModel != null;

    if (!isLoggedIn) {
      MyHelpers.showMessage(
        S.of(context).halamak_ucin_giris,
        AppColors.errorRed,
        context,
      );
      return;
    }

    context.read<FavoriteBloc>().add(ToggleFavoriteProduct(product));
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoriteBloc, bool>((bloc) {
      final s = bloc.state;
      return s is FavoriteLoaded && s.isFavorite(product.id);
    });
    final isSyncing = context.select<FavoriteBloc, bool>((bloc) {
      final s = bloc.state;
      return s is FavoriteLoaded && s.isSyncing(product.id);
    });

    final child = isSyncing
        ? SizedBox(
            height: size,
            width: size,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.amber,
            ),
          )
        : Icon(
            isFav ? Icons.star : Icons.star_border,
            size: size,
            color: isFav ? Colors.amber : AppColors.lightTextSecondary,
          );

    final icon = GestureDetector(
      onTap: isSyncing ? null : () => _onTap(context),
      child: Padding(padding: padding, child: child),
    );

    if (!withBackground) return icon;

    return GestureDetector(
      onTap: isSyncing ? null : () => _onTap(context),
      child: Container(
        padding: padding,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
