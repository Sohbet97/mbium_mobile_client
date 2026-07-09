import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/person/models/person_model.dart';

class PersonRepository {
  final Dio dio;
  final AppPreferences preferences;

  bool _googleInitialized = false;

  PersonRepository({required this.dio, required this.preferences});

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
  }

  String? getSavedToken() => preferences.getString('auth_token');

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
