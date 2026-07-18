import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/network/interceptors.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';

class ApiClient {
  final Dio dio;
  final AppPreferences appPreferences;
  static String baseUrl = 'https://mbium.com/api/buyer';

  // Single-flight lock so concurrent 401s trigger only one /auth/refresh
  // call; everyone else awaits the same Future.
  Future<bool>? _refreshing;

  ApiClient({required this.appPreferences})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          // Every status code resolves as a normal response (never throws),
          // so 401 handling has to live in onResponse, not onError.
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
          final token = appPreferences.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode != 401) {
            return handler.next(response);
          }

          final isRefreshCall = response.requestOptions.path.contains(
            '/auth/refresh',
          );
          final alreadyRetried =
              response.requestOptions.extra['retried'] == true;

          if (!isRefreshCall && !alreadyRetried) {
            final refreshed = await _refreshSession();
            if (refreshed) {
              response.requestOptions.extra['retried'] = true;
              try {
                final retryResponse = await dio.fetch(
                  response.requestOptions,
                );
                return handler.resolve(retryResponse);
              } catch (_) {
                // fall through to the expired-session handling below
              }
            } else {
              await _clearSession();
            }
          }

          showGlobalMessage('Сессия истекла. Пожалуйста, войдите снова.');
          return handler.next(response);
        },
        onError: (e, handler) {
          if (e.type == DioExceptionType.connectionError) {
            showGlobalMessage('Нет подключения к интернету');
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> _refreshSession() {
    return _refreshing ??= _doRefresh().whenComplete(() {
      _refreshing = null;
    });
  }

  Future<bool> _doRefresh() async {
    final refreshToken = appPreferences.getString('refresh_token');
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final url = dio.options.baseUrl.replaceAll('/buyer', '');
      final response = await dio.post(
        '$url/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode != 200) return false;

      final body = response.data as Map<String, dynamic>;
      final newAccessToken = body['accessToken'] as String?;
      final newRefreshToken = body['refreshToken'] as String?;
      if (newAccessToken == null || newAccessToken.isEmpty) return false;

      await appPreferences.setString('auth_token', newAccessToken);
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await appPreferences.setString('refresh_token', newRefreshToken);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _clearSession() async {
    await appPreferences.setString('auth_token', '');
    await appPreferences.setString('refresh_token', '');
    await appPreferences.saveRegistrationStatus(false);
  }
}
