import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/ai_chat/data/ai_chat_repository.dart';
import 'package:mbium_mobile_client/feature/ai_chat/models/ai_chat_message.dart';
import 'package:mbium_mobile_client/feature/ai_chat/models/ai_conversation_model.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final AiChatRepository repository;

  AiChatBloc({required this.repository}) : super(const AiChatState()) {
    on<SendChatMessageEvent>(_onSend);
    on<LoadConversationsEvent>(_onLoadConversations);
    on<OpenConversationEvent>(_onOpenConversation);
    on<SaveConversationEvent>(_onSaveConversation);
    on<StartNewConversationEvent>(_onStartNew);
  }

  FutureOr<void> _onSend(
    SendChatMessageEvent event,
    Emitter<AiChatState> emit,
  ) async {
    final userMessage = AiChatMessage(role: 'user', content: event.content);
    final historyWithUser = [...state.messages, userMessage];
    emit(state.copyWith(messages: historyWithUser, isSending: true, clearError: true));

    try {
      final reply = await repository.sendChatMessage(
        historyWithUser,
        lang: event.lang,
      );
      emit(
        state.copyWith(
          messages: [...historyWithUser, reply],
          isSending: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingConversations: true, clearError: true));
    try {
      final conversations = await repository.getConversations();
      emit(
        state.copyWith(
          conversations: conversations,
          isLoadingConversations: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingConversations: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onOpenConversation(
    OpenConversationEvent event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(isSending: true, clearError: true));
    try {
      final conversation = await repository.getConversation(event.id);
      emit(
        state.copyWith(
          messages: conversation.messages,
          conversationId: conversation.id,
          isSending: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onSaveConversation(
    SaveConversationEvent event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.messages.isEmpty) return;
    emit(state.copyWith(isSending: true, clearError: true));
    try {
      final saved = await repository.createConversation(
        title: event.title,
        messages: state.messages,
      );
      emit(state.copyWith(conversationId: saved.id, isSending: false));
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onStartNew(
    StartNewConversationEvent event,
    Emitter<AiChatState> emit,
  ) async {
    emit(
      state.copyWith(messages: const [], clearConversationId: true, clearError: true),
    );
  }
}
