part of 'ai_chat_bloc.dart';

sealed class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

final class SendChatMessageEvent extends AiChatEvent {
  final String content;
  final String lang;

  const SendChatMessageEvent(this.content, {this.lang = 'ru'});

  @override
  List<Object?> get props => [content, lang];
}

final class LoadConversationsEvent extends AiChatEvent {
  const LoadConversationsEvent();
}

final class OpenConversationEvent extends AiChatEvent {
  final int id;

  const OpenConversationEvent(this.id);

  @override
  List<Object?> get props => [id];
}

final class SaveConversationEvent extends AiChatEvent {
  final String title;

  const SaveConversationEvent(this.title);

  @override
  List<Object?> get props => [title];
}

final class StartNewConversationEvent extends AiChatEvent {
  const StartNewConversationEvent();
}
