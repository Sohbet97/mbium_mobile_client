import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/comments/bloc/comment_bloc.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailCommentWriteWidget extends StatefulWidget {
  final int productId;
  final int orderId;

  const ProductDetailCommentWriteWidget({
    super.key,
    required this.productId,
    required this.orderId,
  });

  @override
  State<ProductDetailCommentWriteWidget> createState() =>
      _ProductDetailCommentWriteWidgetState();
}

class _ProductDetailCommentWriteWidgetState
    extends State<ProductDetailCommentWriteWidget> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0 || _controller.text.trim().isEmpty) return;
    context.read<CommentBloc>().add(
          SubmitCommentEvent(
            CreateCommentRequest(
              productId: widget.productId,
              orderId: widget.orderId,
              rating: _rating,
              comment: _controller.text.trim(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return BlocConsumer<CommentBloc, CommentState>(
      listenWhen: (previous, current) =>
          current is CommentSubmitSuccess || current is CommentSubmitError,
      listener: (context, state) {
        if (state is CommentSubmitSuccess) {
          setState(() {
            _rating = 0;
            _controller.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.teswir_goshuldy)),
          );
        }
        if (state is CommentSubmitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is CommentSubmitting;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.teswir_goshmak, style: textStyles.s13w600clBlack),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (i) {
                  final filled = i < _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        filled ? Icons.star : Icons.star_border,
                        color: AppColors.starYellow,
                        size: 28,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: l10n.teswir_yaz,
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.navWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.navWhite,
                          ),
                        )
                      : Text(l10n.iber),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}