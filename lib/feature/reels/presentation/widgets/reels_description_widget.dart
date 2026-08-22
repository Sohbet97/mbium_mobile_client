import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

/// TikTok-style reel caption: collapses to 2 lines with an inline "…more"
/// glued to the end of the visible text (not on its own row below), and
/// expands/collapses on tap with a smooth height animation.
///
/// [expandedNotifier] is shared with the sibling [ReelPlayerView] so a tap
/// anywhere on the video — not just on the caption itself — collapses it
/// back when it's open, instead of toggling playback.
class ReelsDescriptionWidget extends StatelessWidget {
  const ReelsDescriptionWidget({
    super.key,
    required this.caption,
    required this.shopName,
    required this.expandedNotifier,
    required this.onTapShopName,
  });

  final String caption;
  final ReelShop shopName;
  final ValueNotifier<bool> expandedNotifier;

  /// Called right before navigating to the shop — lets the parent pause the
  /// reel first, so it doesn't keep playing (audio and all) underneath the
  /// shop screen.
  final VoidCallback onTapShopName;

  static const _textStyle = TextStyle(
    color: Colors.white70,
    fontSize: 12.5,
    height: 1.3,
    fontWeight: FontWeight.w400,
    shadows: [
      Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
    ],
  );

  static const _affixStyle = TextStyle(
    color: AppColors.darkTextPrimary,
    fontSize: 12.5,
    height: 1.3,
    fontWeight: FontWeight.w900,
    shadows: [
      Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
    ],
  );

  static const _lessLabel = 'Gizle';

  bool _fitsInTwoLines(BuildContext context, String text, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _textStyle),
      maxLines: 2,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);
    return !painter.didExceedMaxLines;
  }

  /// Longest prefix of [caption] such that `prefix… ` + [affixLabel] still
  /// fits within 2 lines — reserves exact room for the tappable affix so it
  /// never gets clipped or pushed onto a third line.
  String _truncatedFor(
    BuildContext context,
    String caption,
    double maxWidth,
    String affixLabel,
  ) {
    bool fits(int length) {
      final candidate = length >= caption.length
          ? caption
          : '${caption.substring(0, length).trimRight()}… ';
      final painter = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(text: candidate, style: _textStyle),
            TextSpan(text: affixLabel, style: _affixStyle),
          ],
        ),
        maxLines: 2,
        textDirection: Directionality.of(context),
      )..layout(maxWidth: maxWidth);
      return !painter.didExceedMaxLines;
    }

    if (fits(caption.length)) return caption;

    var low = 0;
    var high = caption.length;
    var best = 0;
    while (low <= high) {
      final mid = (low + high) ~/ 2;
      if (fits(mid)) {
        best = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }
    return '${caption.substring(0, best).trimRight()}…';
  }

  @override
  Widget build(BuildContext context) {
    if (caption.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: _buildShop(context),
      );
    }

    final moreLabel = S.of(context).ahlisin_gorkez;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final overflows = !_fitsInTwoLines(context, caption, maxWidth);

        return ValueListenableBuilder<bool>(
          valueListenable: expandedNotifier,
          builder: (context, expanded, _) {
            Widget content;
            if (!overflows) {
              content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShop(context),
                  Text(caption, style: _textStyle),
                ],
              );
            } else if (expanded) {
              content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildShop(context),
                  RichText(
                    text: TextSpan(
                      style: _textStyle,
                      children: [
                        TextSpan(text: '$caption  '),
                        TextSpan(text: _lessLabel, style: _affixStyle),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              final truncated = _truncatedFor(
                context,
                caption,
                maxWidth,
                '  $moreLabel',
              );
              content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShop(context),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                      style: _textStyle,
                      children: [
                        TextSpan(text: '$truncated  '),
                        TextSpan(text: moreLabel, style: _affixStyle),
                      ],
                    ),
                  ),
                ],
              );
            }

            return GestureDetector(
              onTap: overflows
                  ? () => expandedNotifier.value = !expanded
                  : null,
              behavior: HitTestBehavior.opaque,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topLeft,
                child: content,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShop(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapShopName();
        final ShopModel model = ShopModel(id: shopName.id, name: shopName.name);
        Navigator.pushNamed(context, '/shopDetail', arguments: model);
      },
      child: Text(
        shopName.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
