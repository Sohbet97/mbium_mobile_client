import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';

class CategoryRepository {
  final Dio dio;

  CategoryRepository({required this.dio});

  List<CategoryModel>? _categories;

  Future<List<CategoryModel>> getCategories(bool? isRefresh) async {
    if (_categories != null && isRefresh != true) {
      return _categories!;
    }

    try {
      final response = await dio.get('/catalog/categories/tree');
      if (response.statusCode == 200) {
        final data = response.data as List;
        _categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        return _categories!;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
