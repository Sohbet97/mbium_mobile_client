import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ListProductItem extends StatefulWidget {
  const ListProductItem({super.key, required this.model});
  final ProductModel model;
  @override
  State<ListProductItem> createState() => _ListProductItemState();
}

class _ListProductItemState extends State<ListProductItem> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final name = model.name;
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/productDetail', arguments: model);
        },
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.photo, color: Colors.grey.shade200),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Text(
                  '${model.price} ${model.currency}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Spacer(),

                const SizedBox(width: 3),
                Icon(Icons.star, color: Colors.amber, size: 14),
                Text(model.rating.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
