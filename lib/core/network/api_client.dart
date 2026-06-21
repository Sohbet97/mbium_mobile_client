import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  static String baseUrl = 'https://mbium.com/api/buyer';
  String? token;

  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          validateStatus: (status) => true,
          headers: {
            "Content-Type": "application/json",
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36',
          },
        ),
      ) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (token != null && token!.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.type == DioExceptionType.connectionError) {
            print("No Internet");
          }

          if (e.response?.statusCode == 401) {
            print("Unauthorized");
          }

          return handler.next(e);
        },
      ),
    );
  }
}
