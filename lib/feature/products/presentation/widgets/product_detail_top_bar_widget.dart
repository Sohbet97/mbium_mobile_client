import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/search/model/search_model.dart';

/// Alibaba-style floating circular icon buttons (back / favorite / share)
/// replacing the plain [AppBar] actions row.
class ProductDetailTopBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const ProductDetailTopBarWidget({
    super.key,
    required this.product,
    required this.onShare,
  });

  final ProductModel product;
  final VoidCallback onShare;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ProductDetailTopBarWidget> createState() =>
      _ProductDetailTopBarWidgetState();
}

class _ProductDetailTopBarWidgetState extends State<ProductDetailTopBarWidget> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    // NOTE: there's no product-search-by-text endpoint/screen yet —
    // MySearchScreen only handles the image-detect flow so far — so this
    // just opens it the same way the camera/mic buttons already do, rather
    // than faking a results list. Wire in real query handling once a
    // search endpoint exists.
    Navigator.pushNamed(context, '/searchScreen', arguments: SearchModel());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: _CircleIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Expanded(
            child: SearchWidget(
              controller: _searchController,
              onSubmit: _onSubmit,
            ),
          ),
          _CircleIconButton(icon: Icons.share_outlined, onTap: widget.onShare),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({this.icon, this.onTap, this.child})
    : assert(icon != null || child != null);

  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: child ?? Icon(icon, size: 18, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
