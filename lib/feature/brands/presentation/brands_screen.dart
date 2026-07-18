import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/brands/bloc/brand_bloc.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_model.dart';
import 'package:mbium_mobile_client/feature/brands/presentation/widgets/brand_widgets.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';

import '../../../generated/l10n.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final List<BrandModel> _brands = [];

  late final BrandBloc _brandBloc;

  @override
  void initState() {
    super.initState();
    _brandBloc = context.read<BrandBloc>();
    _brandBloc.add(const LoadBrandsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _brandBloc.add(const LoadMoreBrandsEvent());
    }
  }

  void _onSearch() {
    _brandBloc.add(SearchBrandsEvent(_searchController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.brands)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchWidget(
              controller: _searchController,
              onSubmit: _onSearch,
            ),
          ),
          Expanded(
            child: BlocConsumer<BrandBloc, BrandState>(
              bloc: _brandBloc,
              listener: (context, state) {
                if (state is BrandLoading) {
                  _brands.clear();
                }
                if (state is BrandLoaded) {
                  _brands
                    ..clear()
                    ..addAll(state.brands);
                }
                if (state is BrandError) {
                  MyHelpers.showMessage(
                    loc.nasazlyk_yuze_cykdy,
                    AppColors.errorRed,
                    context,
                  );
                }
              },
              builder: (context, state) {
                if (state is BrandLoading) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: brandGridDelegate(),
                    itemCount: 9,
                    itemBuilder: (context, index) => const BrandGridCardShimmer(),
                  );
                }

                if (state is BrandLoaded && _brands.isEmpty) {
                  return Center(
                    child: MyEmptyWidget(emptyText: loc.brand_empty),
                  );
                }

                final isLoadingMore = state is BrandLoaded && state.isLoadingMore;
                final itemCount = _brands.length + (isLoadingMore ? 1 : 0);

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: brandGridDelegate(),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index < _brands.length) {
                      final brand = _brands[index];
                      return BrandGridCard(
                        brand: brand,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/brandDetail',
                          arguments: brand,
                        ),
                      );
                    }
                    return const BrandGridCardShimmer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
