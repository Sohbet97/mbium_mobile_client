import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';
import '../../../../generated/l10n.dart';

class OzBahanyRecentlyWidget extends StatelessWidget {
  const OzBahanyRecentlyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
      builder: (context, state) {
        if (state is! RecentlyViewedLoaded) return const SizedBox.shrink();
        final products = state.products;
        if (products.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.on_gorulen_onumler_section,
                style: textStyles.s16w600clBlack,
              ),
            ),
            const SizedBox(height: 10),
            MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductMassonGridItem(product: products[index]);
              },
            ),
          ],
        );
      },
    );
  }
}