import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/ai/ai_prompt_action_buttons.dart';

class AiInputFieldFab extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  const AiInputFieldFab({
    super.key,
    this.controller,
    this.onSubmitted,
    this.hintText = '',
  });

  void _onMicResult(String text) {
    final target = controller;
    if (target == null) return;
    target.text = text;
    target.selection = TextSelection.fromPosition(
      TextPosition(offset: target.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetWidth = screenWidth > 400 ? 360 : screenWidth - 32;

    return Container(
      width: targetWidth,
      height: 114,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x267A9443),
            blurRadius: 12.1,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.only(
                  top: 4,
                  left: 8,
                  right: 8,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const AiCameraButton(),
                  const SizedBox(width: 10),
                  AiMicButton(onResult: _onMicResult),
                ],
              ),
              _SendButton(controller: controller, onSubmitted: onSubmitted),
            ],
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.controller, required this.onSubmitted});

  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  void _submit() {
    final text = controller?.text ?? '';
    if (text.trim().isEmpty) return;
    onSubmitted?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final listenable = controller;
    if (listenable == null) {
      return _buildButton(enabled: true);
    }
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: listenable,
      builder: (context, value, _) {
        return _buildButton(enabled: value.text.trim().isNotEmpty);
      },
    );
  }

  Widget _buildButton({required bool enabled}) {
    return GestureDetector(
      onTap: enabled ? _submit : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? AppColors.primaryGreen : Colors.grey.shade300,
        ),
        child: Icon(
          Icons.arrow_upward_rounded,
          size: 18,
          color: enabled ? Colors.white : Colors.grey.shade500,
        ),
      ),
    );
  }
}
