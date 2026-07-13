enum UserType { user, shop }

class PersonModel {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final String? avatar;
  final String token;

  const PersonModel({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.avatar,
    required this.token,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return PersonModel(
      id: user['id']?.toString() ?? '',
      email: user['email'] as String? ?? '',
      name: user['name'] as String?,
      surname: user['surname'] as String?,
      avatar: user['avatar'] as String?,
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'avatar': avatar,
      'token': token,
    };
  }
}
