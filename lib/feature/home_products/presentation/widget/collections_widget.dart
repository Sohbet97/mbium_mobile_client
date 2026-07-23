import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/collections/bloc/collection_bloc.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_model.dart';
import 'package:mbium_mobile_client/feature/collections/extensions/collection_extensions.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/Horizontal_product_list_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ProductCollectionsWidget extends StatefulWidget {
  const ProductCollectionsWidget({super.key});

  @override
  State<ProductCollectionsWidget> createState() =>
      _ProductCollectionsWidgetState();
}

class _ProductCollectionsWidgetState extends State<ProductCollectionsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionBloc>().add(LoadAllCollectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
      buildWhen: (previous, current) =>
          current is! LoadAllCollectionsSuccess ||
          previous is! LoadAllCollectionsSuccess ||
          previous.collections != current.collections,
      builder: (context, state) {
        if (state is LoadAllCollectionsError) {
          return const SizedBox.shrink();
        }

        if (state is LoadAllCollectionsSuccess) {
          final collections = state.collections;
          if (collections.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              for (final collection in collections)
                _CollectionSection(collection: collection),
            ],
          );
        }

        return const _CollectionSectionShimmer();
      },
    );
  }
}

class _CollectionSection extends StatefulWidget {
  final CollectionModel collection;

  const _CollectionSection({required this.collection});

  @override
  State<_CollectionSection> createState() => _CollectionSectionState();
}

class _CollectionSectionState extends State<_CollectionSection> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionBloc>().add(
      LoadCollectionProductsEvent(collectionId: widget.collection.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.read<MainBloc>().state.languageCode;
    final localization = S.of(context);

    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        if (state is! LoadAllCollectionsSuccess) {
          return const SizedBox.shrink();
        }

        final products = state.productsByCollection[widget.collection.id];

        if (products == null) {
          return const _CollectionSectionShimmer();
        }

        if (products.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/collectionDetail',
                  arguments: widget.collection,
                ),
                title: Text(
                  widget.collection.collectionNameByLanguage(languageCode),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: AppColors.primaryGreen,
                ),
                subtitle: Text(
                  "${localization.jemi}: ${widget.collection.productCount}",
                  style: TextStyle(fontSize: 11),
                ),
              ),
              HorizontalProductListWidget(products: products),
            ],
          ),
        );
      },
    );
  }
}

class _CollectionSectionShimmer extends StatelessWidget {
  const _CollectionSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 140,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 155,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
