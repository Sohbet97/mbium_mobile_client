import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';

class RegShopButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const RegShopButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52, // Keeps the layout rigid and fixed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xff4B9976), Color(0xff077844)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: context.appTextStyles.s20w700clWhite.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(32),
                onTap: onTap, // Your button logic
              ),
            ),
          ),
        ],
      ),
    );
  }
}
