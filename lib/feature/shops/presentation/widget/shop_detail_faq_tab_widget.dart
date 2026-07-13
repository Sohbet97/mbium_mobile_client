import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class _LocalMessage {
  final String text;
  final bool isMine;
  final DateTime time;
  const _LocalMessage({required this.text, required this.isMine, required this.time});
}

class ShopDetailFaqTabWidget extends StatefulWidget {
  final ShopDetailModel model;

  const ShopDetailFaqTabWidget({super.key, required this.model});

  @override
  State<ShopDetailFaqTabWidget> createState() => _ShopDetailFaqTabWidgetState();
}

class _ShopDetailFaqTabWidgetState extends State<ShopDetailFaqTabWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_LocalMessage> _messages = [];
  bool _introAdded = false;

 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_introAdded) {
      _messages.add(
        _LocalMessage(
          text: S.of(context).salam_komek,
          isMine: false,
          time: DateTime.now(),
        ),
      );
      _introAdded = true;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_LocalMessage(text: text, isMine: true, time: DateTime.now()));
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: message.isMine
                    ? _MyMessageBubble(message: message, l10n: l10n)
                    : _ShopMessageCard(message: message, model: widget.model, l10n: l10n),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.navBarGrey),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            onSubmitted: (_) => _send(),
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: l10n.soragynyzy_yazyn,
                              hintStyle: const TextStyle(
                                  fontSize: 13, color: AppColors.lightTextSecondary),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.attach_file,
                              color: AppColors.lightTextSecondary, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: AppColors.navWhite, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Text(
            l10n.adaty_jogap_wagty,
            style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }
}

class _ShopMessageCard extends StatelessWidget {
  final _LocalMessage message;
  final ShopDetailModel model;
  final S l10n;

  const _ShopMessageCard({required this.message, required this.model, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final time = DateFormat('HH:mm', 'en').format(message.time);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
          backgroundImage:
              model.logo != null && model.logo!.isNotEmpty ? NetworkImage(model.logo!) : null,
          child: model.logo == null || model.logo!.isEmpty
              ? const Icon(Icons.store_outlined, color: AppColors.primaryGreen, size: 16)
              : null,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.localizedName, style: textStyles.s13w600clBlack),
                const SizedBox(height: 4),
                Text(
                  message.text,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.lightTextPrimary, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(
                  '${l10n.bu_gun}, $time',
                  style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MyMessageBubble extends StatelessWidget {
  final _LocalMessage message;
  final S l10n;

  const _MyMessageBubble({required this.message, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm', 'en').format(message.time);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.lightTextPrimary, height: 1.4),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${l10n.bu_gun}, $time',
                      style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, size: 14, color: AppColors.primaryGreen),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}