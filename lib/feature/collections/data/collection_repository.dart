import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class CollectionRepository {
  final Dio dio;

  CollectionRepository({required this.dio});

  Future<List<CollectionModel>> getCollections() async {
    final response = await dio.get('/catalog/collections');

    if (response.statusCode != 200) {
      throw Exception('status code: ${response.statusCode}');
    }

    final data = response.data['data'] as List? ?? [];
    return data
        .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ProductModel>> getCollectionProducts(
    int collectionId, {
    int limit = 10,
  }) async {
    final response = await dio.get(
      '/catalog/collections/$collectionId',
      queryParameters: {'limit': limit},
    );

    if (response.statusCode != 200) {
      throw Exception('status code: ${response.statusCode}');
    }

    final model = response.data['model'] as Map<String, dynamic>? ?? {};
    final products = model['products'] as List? ?? [];
    return products
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
