import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_comment_input.dart';

/// TikTok-style comments drawer: docked below the video (which shrinks to
/// stay fully visible above it, via [ReelFeedItem]) rather than a route-level
/// modal that would just cover the video up.
///
/// No comments backend exists yet for reels — this is the UI shell (empty
/// state + input) so the button has somewhere to go; wire in a real list
/// once there's a comments endpoint to back it.
class CommentsSheet extends StatelessWidget {
  const CommentsSheet({
    super.key,
    required this.commentController,
    required this.onSubmit,
    required this.onClose,
    this.heightFraction = 0.5,
  });

  final TextEditingController commentController;
  final VoidCallback onSubmit;
  final VoidCallback onClose;
  final double heightFraction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * heightFraction,
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
                const Expanded(
                  child: Text(
                    'Teswirler',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                    onPressed: onClose,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          const Expanded(
            child: Center(
              child: Text(
                'Entek teswir ýok',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
              child: ReelsCommentInput(
                controller: commentController,
                onSubmit: onSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
