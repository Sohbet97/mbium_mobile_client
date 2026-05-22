import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/gradient_theme.dart';

class RecommendedProductCard extends StatelessWidget {
  final String productName;
  final List<String> advantages;
  const RecommendedProductCard({
    super.key,
    required this.productName,
    required this.advantages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        gradient: Theme.of(
          context,
        ).extension<GradientTheme>()!.containerGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productName),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                advantages.length,
                (int index) => Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: Theme.of(context).cardColor,
                    ),
                    SizedBox(width: 5),
                    Text(advantages[index]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
