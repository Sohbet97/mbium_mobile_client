import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/reviews/bloc/review_bloc.dart';
import 'package:mbium_mobile_client/feature/reviews/models/review_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReviewWriteSheetWidget extends StatefulWidget {
  final int productId;
  final int orderId;

  const ReviewWriteSheetWidget({
    super.key,
    required this.productId,
    required this.orderId,
  });

  static Future<void> show(
    BuildContext context, {
    required int productId,
    required int orderId,
  }) {
    final bloc = context.read<ReviewBloc>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: ReviewWriteSheetWidget(productId: productId, orderId: orderId),
      ),
    );
  }

  @override
  State<ReviewWriteSheetWidget> createState() => _ReviewWriteSheetWidgetState();
}

class _ReviewWriteSheetWidgetState extends State<ReviewWriteSheetWidget> {
  int _rating = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0 || _controller.text.trim().isEmpty) return;
    context.read<ReviewBloc>().add(
          SubmitReviewEvent(
            CreateReviewRequest(
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

    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSubmitSuccess) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.teswir_goshmak, style: textStyles.s16w600clBlack),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < _rating;
                    return GestureDetector(
                      onTap: () => setState(() => _rating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          filled ? Icons.star : Icons.star_border,
                          color: AppColors.starYellow,
                          size: 32,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: l10n.teswir_yaz,
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  final isSubmitting = state is ReviewSubmitting;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.navWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.navWhite,
                              ),
                            )
                          : Text(l10n.iber),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}