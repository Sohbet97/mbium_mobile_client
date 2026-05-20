import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/home/models/ai_recomendasion_model.dart';

class AiRepository {
  final Dio dio;
  final AppPreferences appPreferences;

  AiRepository({required this.dio, required this.appPreferences});

  Future<List<AiRecommendationModel>> loadRecomendasionList() async {
    final list = <AiRecommendationModel>[
      AiRecommendationModel(
        id: 1,
        title: 'Siziň indiki iň gowy öndürijiňiz',
        subtitle: 'Gurluşyk harytlaryny öndürýän telekeçi gözleýän',
        prompt: '',
        emoji: '🔎',
      ),

      AiRecommendationModel(
        id: 2,
        title: 'Özüňize täze tendensiýalary açyň',
        subtitle: 'Welaýatlar boýunça haýsy haryt köp salynandygyny açyň',
        prompt: '',
        emoji: '🔎',
      ),

      AiRecommendationModel(
        id: 3,
        title: 'Özüňize täze tendensiýalary açyň',
        prompt: '',
      ),

      AiRecommendationModel(
        id: 4,
        title: 'Harytlarňy AI dizaýn et',
        prompt: '',
      ),

      AiRecommendationModel(id: 5, title: 'Haryt gözle', prompt: ''),
      AiRecommendationModel(
        id: 6,
        title: 'Iň köp satylýan harytlary analiz et',
        prompt: '',
      ),

      AiRecommendationModel(
        id: 7,
        title: 'Bazar mümkinçiligini analiz et',
        prompt: '',
      ),

      AiRecommendationModel(
        id: 8,
        title: 'Özüňize täze tendensiýalary açyň',
        prompt: '',
      ),
    ];

    return list;
  }
}
