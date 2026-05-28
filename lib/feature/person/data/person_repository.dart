import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/person/models/person_model.dart';

class PersonRepository {
  final Dio dio;
  final AppPreferences preferences;

  bool _googleInitialized = false;

  PersonRepository({required this.dio, required this.preferences});

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize();
    _googleInitialized = true;
  }

  Future<PersonModel> signInWithGoogle() async {
    await _ensureGoogleInitialized();

    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) throw Exception('Failed to get Google ID token');

    final response = await dio.post(
      '/auth/google',
      data: {'id_token': idToken},
    );

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
}
