import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/person/models/person_model.dart';

class PersonRepository {
  final Dio dio;
  final AppPreferences preferences;

  bool _googleInitialized = false;

  static const _personKey = 'person_data';

  PersonRepository({required this.dio, required this.preferences});

  PersonModel? getSavedPerson() {
    final raw = preferences.getString(_personKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return PersonModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // Web client ID from google-services.json (client_type: 3)
  static const _webClientId =
      '1021753471406-22kjuhouep58uf0ch8sd5aqq06qniv2q.apps.googleusercontent.com';

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize(serverClientId: _webClientId);
    _googleInitialized = true;
  }

  Future<PersonModel> signInWithGoogle() async {
    await _ensureGoogleInitialized();

    final account = await GoogleSignIn.instance.authenticate();
    final auth = account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) throw Exception('Failed to get Google ID token');

    final baseUrl = dio.options.baseUrl;

    final newUrl = baseUrl.replaceAll('/buyer', '');

    final response = await dio.post(
      '$newUrl/auth/google',
      data: {'id_token': idToken},
    );

    print('response auth: $response');
    print('response auth: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data as Map<String, dynamic>;
      final person = PersonModel.fromJson(data);
      await preferences.saveRegistrationStatus(true);
      await preferences.saveGostUser(false);
      await preferences.setString('auth_token', person.token);
      await preferences.setString(_personKey, jsonEncode(person.toJson()));
      return person;
    }

    throw Exception(
      (response.data as Map<String, dynamic>?)?['message'] ??
          'Ошибка авторизации через Google',
    );
  }

  Future<void> signOut() async {
    await _ensureGoogleInitialized();
    await GoogleSignIn.instance.signOut();
    await preferences.saveRegistrationStatus(false);
    await preferences.setString('auth_token', '');
    await preferences.setString(_personKey, '');
  }

  String? getSavedToken() => preferences.getString('auth_token');

  /// GET /auth/me — refreshes the signed-in user's profile using the saved
  /// bearer token. Returns null (instead of throwing) on any failure so
  /// callers can fall back to the locally cached copy.
  Future<PersonModel?> fetchMe({CancelToken? cancelToken}) async {
    try {
      final baseUrl = dio.options.baseUrl;
      final newUrl = baseUrl.replaceAll('/buyer', '');
      final response = await dio.get(
        '$newUrl/auth/me',
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) return null;

      final body = response.data as Map<String, dynamic>;
      final raw = (body['model'] ?? body) as Map<String, dynamic>;
      final shop = raw['shop'] as Map<String, dynamic>?;

      final person = PersonModel(
        id: raw['id']?.toString() ?? '',
        email: raw['email'] as String? ?? '',
        name: raw['name'] as String?,
        surname: raw['surname'] as String?,
        avatar: raw['avatar'] as String? ?? shop?['logo'] as String?,
        token: getSavedToken() ?? '',
      );
      await preferences.setString(_personKey, jsonEncode(person.toJson()));
      return person;
    } catch (_) {
      return null;
    }
  }

  Future<String> createNewUser({
    required String phoneNumber,
    required String password,
    required String name,
    required String surName,
    required String? email,
    required DateTime? birthday,
  }) async {
    try {
      final data = {
        "phone_number": phoneNumber,
        "password": password,
        "name": name,
        "surname": surName,
        "email": email,
        "birth_date": birthday?.toIso8601String(),
      };
      final url = dio.options.baseUrl.replaceAll('/buyer', '');
      final response = await dio.post('$url/auth/register', data: data);

      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>?;
        final sessionId = data?['session_id'];

        return sessionId;
      }
      throw Exception('code : ${response.statusCode}');
    } catch (e) {
      throw Exception(e);
    }
  }
}
