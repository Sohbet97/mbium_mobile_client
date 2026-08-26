import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/comments/bloc/comment_bloc.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_comment_input.dart';

import '../../../../generated/l10n.dart';

/// TikTok-style comments drawer: docked below the video (which shrinks to
/// stay fully visible above it, via [ReelFeedItem]) rather than a route-level
/// modal that would just cover the video up.
///
/// Backed by the same product-comments [CommentBloc] as the product detail
/// screen — a reel's comments are its linked product's comments. A reel with
/// no linked product ([productId] null) can't show or post any.
class CommentsSheet extends StatefulWidget {
  const CommentsSheet({
    super.key,
    required this.productId,
    required this.commentController,
    required this.onClose,
    this.heightFraction = 0.5,
  });

  final int? productId;
  final TextEditingController commentController;
  final VoidCallback onClose;
  final double heightFraction;

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  @override
  void initState() {
    super.initState();
    final productId = widget.productId;
    if (productId != null) {
      context.read<CommentBloc>().add(LoadCommentsEvent(productId: productId));
    }
  }

  void _submit() {
    final productId = widget.productId;
    final body = widget.commentController.text.trim();
    if (productId == null || body.isEmpty) return;

    context.read<CommentBloc>().add(
      SubmitCommentEvent(
        CreateCommentRequest(productId: productId, body: body),
      ),
    );
    widget.commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final productId = widget.productId;

    return Container(
      height: MediaQuery.of(context).size.height * widget.heightFraction,
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    localization.teswirler,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                    onPressed: widget.onClose,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: productId == null
                ? Center(
                    child: Text(
                      localization.teswir_yuklenmedi,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                : BlocConsumer<CommentBloc, CommentState>(
                    listenWhen: (previous, current) =>
                        current is CommentSubmitError,
                    listener: (context, state) {
                      if (state is CommentSubmitError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CommentLoaded && state.productId == productId) {
                        if (state.comments.isEmpty) {
                          return const Center(
                            child: Text(
                              'Entek teswir ýok',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: state.comments.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (context, index) =>
                              _ReelCommentRow(comment: state.comments[index]),
                        );
                      }

                      if (state is CommentError) {
                        return Center(
                          child: Text(
                            localization.teswir_yuklenmedi,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                          strokeWidth: 2,
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
              child: ReelsCommentInput(
                controller: widget.commentController,
                onSubmit: _submit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReelCommentRow extends StatelessWidget {
  const _ReelCommentRow({required this.comment});

  final CommentModel comment;

  String get _initials {
    final name = comment.author.fullName;
    if (name.isEmpty) return '?';
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = comment.author.thumbnail;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white24,
          backgroundImage: thumbnail != null && thumbnail.isNotEmpty
              ? NetworkImage(thumbnail)
              : null,
          child: thumbnail == null || thumbnail.isEmpty
              ? Text(
                  _initials,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.author.fullName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                comment.body,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
