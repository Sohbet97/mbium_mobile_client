import 'package:flutter/material.dart';

class ShopDetailFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const ShopDetailFixedHeaderDelegate({
    required this.height,
    required this.child,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant ShopDetailFixedHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}