import 'package:flutter/material.dart';

class AiInputFieldFab extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onMicPressed;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  const AiInputFieldFab({
    super.key,
    this.controller,
    this.onCameraPressed,
    this.onMicPressed,
    this.onSubmitted,
    this.hintText = 'Öz islegiňiz beýan ediň...',
  });

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
              _buildIconButton(
                icon: Icons.camera_alt_outlined,
                onTap: onCameraPressed,
              ),
              _buildIconButton(
                icon: Icons.mic_none_rounded,
                onTap: onMicPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: GestureDetector(onTap: onTap, child: Icon(icon, size: 18)),
    );
  }
}
