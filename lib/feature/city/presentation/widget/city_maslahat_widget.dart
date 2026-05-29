import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/section_header_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_horizontal_item.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n.dart';

class CityMaslahatWidget extends StatefulWidget {
  const CityMaslahatWidget({super.key});

  @override
  State<CityMaslahatWidget> createState() => _CityMaslahatWidgetState();
}

class _CityMaslahatWidgetState extends State<CityMaslahatWidget> {
  final _scrollController = ScrollController();
  final List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductBloc>().add(LoadMoreProducts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductLoaded) {
          setState(() => _products.addAll(state.products));
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeaderWidget(
              title: l10n.maslahat_beriyanler,
              subtitle: l10n.maslahat_beriyanler_subtitle,
              onSeeAll: () {},
            ),
            const SizedBox(height: 10),
            if (_products.isNotEmpty)
              SizedBox(
                height: 180,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length +
                      (state is ProductLoaded && state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < _products.length) {
                      return ProductHorizontalItem(
                        productModel: _products[index],
                        width: 120,
                      );
                    }
                    return Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.surface,
                      highlightColor: AppColors.lightBg,
                      child: Container(
                        width: 110,
                        height: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}