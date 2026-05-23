import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/home/models/ai_recomendasion_model.dart';

class AiRepository {
  final Dio dio;
  final AppPreferences appPreferences;

  AiRepository({required this.dio, required this.appPreferences});

  List<AiRecommendationModel>? _list;

  Future<List<AiRecommendationModel>> loadRecomendasionList() async {
    if (_list != null && _list!.isNotEmpty) {
      return _list!;
    }
    try {
      final response = await dio.get('/ai/recommendations');

      if (response.statusCode != 200) {
        throw Exception('Status code: ${response.statusCode}');
      }

      final data = response.data['data'];
      _list = (data as List)
          .map((item) => AiRecommendationModel.fromJson(item))
          .toList();
      return _list!;
    } catch (e) {
      throw Exception(e);
    }
  }
}
