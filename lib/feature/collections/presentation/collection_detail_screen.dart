import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_model.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_repository.dart';
import 'package:mbium_mobile_client/feature/collections/extensions/collection_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/l10n.dart';

class CollectionDetailScreen extends StatefulWidget {
  const CollectionDetailScreen({super.key, required this.collection});

  final CollectionModel collection;

  @override
  State<CollectionDetailScreen> createState() =>
      _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  late final Future<List<ProductModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<CollectionRepository>().getCollectionProducts(
      widget.collection.id,
      limit: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    final languageCode = context.read<MainBloc>().state.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.collectionNameByLanguage(languageCode)),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CustomScrollView(
              slivers: [
                SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childCount: 6,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(height: 200, color: Colors.white),
                  ),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(snapshot.error.toString()),
              ),
            );
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Center(child: MyEmptyWidget(emptyText: loc.noDataAvailable));
          }

          return CustomScrollView(
            slivers: [
              SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childCount: products.length,
                itemBuilder: (context, index) =>
                    ProductMassonGridItem(product: products[index]),
              ),
            ],
          );
        },
      ),
    );
  }
}
