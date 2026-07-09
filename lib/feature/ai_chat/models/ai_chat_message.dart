class AiChatMessage {
  final String role;
  final String content;

  const AiChatMessage({required this.role, required this.content});

  bool get isUser => role == 'user';
  bool get isAssistant => !isUser;

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      role: json['role'] as String? ?? 'assistant',
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'role': role, 'content': content};
  }
}
