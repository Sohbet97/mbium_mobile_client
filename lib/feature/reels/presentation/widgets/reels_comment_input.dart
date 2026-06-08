import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

class ReelsCommentInput extends StatelessWidget {
  const ReelsCommentInput({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final localization = S.of(context);
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                hintText: localization.oz_pikirini_yaz,
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          GestureDetector(
            onTap: onSubmit,
            child: Icon(Icons.send, color: color),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
