enum UserType { user, shop }

class PersonModel {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final String? phone;
  final String? avatar;
  final String token;
  final String? refreshToken;

  const PersonModel({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.phone,
    this.avatar,
    required this.token,
    this.refreshToken,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return PersonModel(
      id: user['id']?.toString() ?? '',
      email: user['email'] as String? ?? '',
      name: user['name'] as String?,
      surname: user['surname'] as String?,
      // Registration sends `phone_number`; accept a plain `phone` too in
      // case the profile endpoints ever shorten the key.
      phone: user['phone_number'] as String? ?? user['phone'] as String?,
      avatar: user['avatar'] as String?,
      // Login/refresh responses use `accessToken`; older cached copies used
      // `token` — accept either.
      token:
          json['token'] as String? ?? json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'phone_number': phone,
      'avatar': avatar,
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}
