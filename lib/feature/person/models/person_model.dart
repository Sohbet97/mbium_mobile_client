enum UserType { user, shop }

class PersonModel {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final String token;

  const PersonModel({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    required this.token,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      token: json['token'] as String? ?? '',
    );
  }
}
