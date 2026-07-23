import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/ai_chat/models/ai_chat_message.dart';
import 'package:mbium_mobile_client/feature/ai_chat/models/ai_conversation_model.dart';

class AiChatRepository {
  final Dio dio;

  AiChatRepository({required this.dio});

  /// POST /ai/chat — stateless: sends the full message history and gets a
  /// single assistant reply back. Doesn't persist anything by itself; call
  /// [createConversation] separately to save the exchange.
  Future<AiChatMessage> sendChatMessage(
    List<AiChatMessage> messages, {
    String lang = 'ru',
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/ai/chat',
        data: {'messages': messages.map((e) => e.toJson()).toList(), 'lang': lang},
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to send chat message: ${response.statusCode}');
      }

      final body = response.data;

      // The server streams the reply as Server-Sent Events (`data: {...}`
      // lines terminated by `data: [DONE]`) rather than a single JSON
      // object, so dio hands it back as a raw String.
      if (body is String) {
        return AiChatMessage(role: 'assistant', content: _parseSseText(body));
      }

      final raw = body is Map<String, dynamic> && body['data'] is Map
          ? body['data'] as Map<String, dynamic>
          : body as Map<String, dynamic>;
      return AiChatMessage.fromJson(raw);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error sending chat message: $e');
    }
  }

  String _parseSseText(String raw) {
    final buffer = StringBuffer();
    for (final line in raw.split('\n')) {
      final trimmed = line.trim();
      if (!trimmed.startsWith('data:')) continue;

      final payload = trimmed.substring(5).trim();
      if (payload.isEmpty || payload == '[DONE]') continue;

      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map && decoded['text'] is String) {
          buffer.write(decoded['text'] as String);
        }
      } catch (_) {
        // Skip malformed chunks instead of failing the whole reply.
      }
    }
    return buffer.toString();
  }

  /// GET /ai/conversations — list of saved conversations (no messages).
  Future<List<AiConversationModel>> getConversations({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get('/ai/conversations', cancelToken: cancelToken);

      if (response.statusCode != 200) {
        throw Exception('Failed to load conversations: ${response.statusCode}');
      }

      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return data
          .map((e) => AiConversationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching conversations: $e');
    }
  }

  /// POST /ai/conversations — saves a title + message history as a new
  /// conversation.
  Future<AiConversationModel> createConversation({
    required String title,
    required List<AiChatMessage> messages,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/ai/conversations',
        data: {'title': title, 'messages': messages.map((e) => e.toJson()).toList()},
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create conversation: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final raw = (body['model'] ?? body['data'] ?? body) as Map<String, dynamic>;
      return AiConversationModel.fromJson(raw);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error creating conversation: $e');
    }
  }

  /// GET /conversations/{id} — full conversation with messages.
  /// Note: unlike the other three endpoints this one has no `/ai` prefix —
  /// that's what was specified, kept as-is.
  Future<AiConversationModel> getConversation(
    int id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get('/conversations/$id', cancelToken: cancelToken);

      if (response.statusCode != 200) {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final raw = body['model'] as Map<String, dynamic>;
      return AiConversationModel.fromJson(raw);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching conversation: $e');
    }
  }
}
