import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).hoverColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Image.asset(
              'assets/images/example_product_image.png',
              height: 51,
              width: 27,
            ),
          ),
        ),
        Text(category.name),
      ],
    );
  }
}
