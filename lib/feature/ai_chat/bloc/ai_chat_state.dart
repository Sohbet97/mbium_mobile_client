part of 'ai_chat_bloc.dart';

class AiChatState extends Equatable {
  final List<AiChatMessage> messages;
  final bool isSending;
  final int? conversationId;
  final List<AiConversationModel> conversations;
  final bool isLoadingConversations;
  final String? errorMessage;

  const AiChatState({
    this.messages = const [],
    this.isSending = false,
    this.conversationId,
    this.conversations = const [],
    this.isLoadingConversations = false,
    this.errorMessage,
  });

  AiChatState copyWith({
    List<AiChatMessage>? messages,
    bool? isSending,
    int? conversationId,
    bool clearConversationId = false,
    List<AiConversationModel>? conversations,
    bool? isLoadingConversations,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      conversationId: clearConversationId
          ? null
          : (conversationId ?? this.conversationId),
      conversations: conversations ?? this.conversations,
      isLoadingConversations:
          isLoadingConversations ?? this.isLoadingConversations,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    messages,
    isSending,
    conversationId,
    conversations,
    isLoadingConversations,
    errorMessage,
  ];
}
