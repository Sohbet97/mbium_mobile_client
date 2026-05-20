enum ChatRole { user, ai }

class AiHistoryModel {
  final String id;
  final String text;
  final ChatRole role;
  final DateTime dateTime;
  final bool isSuccess;
  final String? intentType;

  AiHistoryModel({
    required this.id,
    required this.text,
    required this.role,
    required this.dateTime,
    this.isSuccess = true,
    this.intentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'role': role.name,
      'dateTime': dateTime.toIso8601String(),
      'isSuccess': isSuccess ? 1 : 0,
      'intentType': intentType,
    };
  }

  factory AiHistoryModel.fromMap(Map<String, dynamic> map) {
    return AiHistoryModel(
      id: map['id'] as String,
      text: map['text'] as String,
      role: ChatRole.values.byName(map['role'] as String),
      dateTime: DateTime.parse(map['dateTime'] as String),
      isSuccess: map['isSuccess'] == 1 || map['isSuccess'] == true,
      intentType: map['intentType'] as String?,
    );
  }

  AiHistoryModel copyWith({
    String? id,
    String? text,
    ChatRole? role,
    DateTime? dateTime,
    bool? isSuccess,
    String? intentType,
  }) {
    return AiHistoryModel(
      id: id ?? this.id,
      text: text ?? this.text,
      role: role ?? this.role,
      dateTime: dateTime ?? this.dateTime,
      isSuccess: isSuccess ?? this.isSuccess,
      intentType: intentType ?? this.intentType,
    );
  }
}
