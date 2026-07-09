import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/ai_chat/bloc/ai_chat_bloc.dart';
import 'package:mbium_mobile_client/feature/home/bloc/ai_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_chat_messages_list.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_conversations_sheet.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_recommendations_list.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/bonus_banner_card.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/promt_filed_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/refresh_button.dart';

import '../../../../generated/l10n.dart';

class AiAgetntPage extends StatefulWidget {
  const AiAgetntPage({super.key});

  @override
  State<AiAgetntPage> createState() => _AiAgetntPageState();
}

class _AiAgetntPageState extends State<AiAgetntPage> {
  late AiBloc _aiBloc;
  late AiChatBloc _aiChatBloc;
  final _promptController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _aiBloc = context.read<AiBloc>();
    _aiBloc.add(GetRecomendasionListEvent());
    _aiChatBloc = context.read<AiChatBloc>();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendPrompt(String text) {
    final content = text.trim();
    if (content.isEmpty) return;
    _promptController.clear();
    _aiChatBloc.add(SendChatMessageEvent(content));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _openHistory() {
    _aiChatBloc.add(const LoadConversationsEvent());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocBuilder<AiChatBloc, AiChatState>(
          bloc: _aiChatBloc,
          builder: (context, state) {
            return AiConversationsSheet(
              conversations: state.conversations,
              isLoading: state.isLoadingConversations,
              onSelect: (id) => _aiChatBloc.add(OpenConversationEvent(id)),
              onStartNew: () =>
                  _aiChatBloc.add(const StartNewConversationEvent()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return BlocConsumer<AiBloc, AiState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: AiInputFieldFab(
            controller: _promptController,
            onSubmitted: _sendPrompt,
          ),
          body: BlocConsumer<AiChatBloc, AiChatState>(
            listener: (context, chatState) {
              if (chatState.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(chatState.errorMessage!)),
                );
              }
              // Persist the very first exchange of a new conversation so it
              // shows up in history without a separate "save" action.
              if (chatState.conversationId == null &&
                  !chatState.isSending &&
                  chatState.messages.length >= 2) {
                _aiChatBloc.add(
                  SaveConversationEvent(chatState.messages.first.content),
                );
              }
            },
            builder: (context, chatState) {
              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AiHistoryButton(onTap: _openHistory),
                        BonusBannerCard(
                          title: localization.derejani_galdyr,
                          coinIcon: 'assets/images/coin_image.png',
                          coinQuantity: '20',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    if (chatState.messages.isEmpty)
                      AiRecommendationsList(onSelectPrompt: _sendPrompt)
                    else
                      AiChatMessagesList(
                        messages: chatState.messages,
                        isSending: chatState.isSending,
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
