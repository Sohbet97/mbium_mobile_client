import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';

class PersonRepository {
  final Dio dio;
  final AppPreferences preferences;

  PersonRepository({required this.dio, required this.preferences});
}
