import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';

class OrderRepository {
  final Dio dio;
  final AppPreferences preferences;

  OrderRepository({required this.dio, required this.preferences});
}
