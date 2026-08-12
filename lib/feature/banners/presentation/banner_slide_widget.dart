import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/app_text_styles.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// One banner image with a title/subtitle/CTA — shared slide content for
/// any banner carousel (home hero, sidebar, category top, ...). The text
/// block is [Positioned] (not Column+Spacer), so it sizes itself naturally
/// and just clips against the card instead of throwing a RenderFlex
/// overflow when a small carousel slot can't fit it.
///
/// [compact] switches to a tighter single-row subtitle+CTA layout with
/// smaller type, for small slots like [CategoryBannerStripWidget]'s strip
/// cards — full-size placements (home hero, sidebar, the single category
/// top banner) should leave it `false`.
class BannerSlideWidget extends StatelessWidget {
  final BannerModel banner;
  final bool compact;

  const BannerSlideWidget({
    super.key,
    required this.banner,
    this.compact = false,
  });

  Future<void> _onTap(BuildContext context) async {
    final shop = banner.shop;
    if (shop?.id != null) {
      Navigator.pushNamed(
        context,
        '/shopDetail',
        arguments: ShopModel(id: shop!.id, name: shop.name),
      );
      return;
    }

    final link = banner.linkUrl?.isNotEmpty == true
        ? banner.linkUrl
        : banner.buttonUrl;
    if (link == null || link.isEmpty) return;

    final uri = Uri.tryParse(link);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final imageUrl = banner.resolvedImageUrl;
    final title = banner.title?.isNotEmpty ?? false ? banner.title! : null;
    final subtitle = banner.subtitle?.isNotEmpty ?? false
        ? banner.subtitle!
        : null;
    final buttonLabel = banner.buttonText?.isNotEmpty ?? false
        ? banner.buttonText!
        : null;
    final hasText = title != null || subtitle != null || buttonLabel != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          imageUrl == null || imageUrl.isEmpty
              ? _placeholder()
              : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  errorWidget: (_, _, _) => _placeholder(),
                ),
          if (hasText)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                padding: compact
                    ? const EdgeInsets.fromLTRB(10, 16, 10, 10)
                    : const EdgeInsets.fromLTRB(12, 24, 12, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.3, 1],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.82),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: textStyles.s14w400clWhite.copyWith(
                          fontSize: compact ? 14 : 15,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (compact) ...[
                      if (subtitle != null || buttonLabel != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (subtitle != null)
                              Expanded(
                                child: Text(
                                  subtitle,
                                  style: textStyles.s14w400clWhite.copyWith(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.82),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            if (subtitle != null && buttonLabel != null)
                              const SizedBox(width: 8),
                            if (buttonLabel != null)
                              _CtaButton(
                                label: buttonLabel,
                                textStyles: textStyles,
                                compact: true,
                              ),
                          ],
                        ),
                      ],
                    ] else ...[
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: textStyles.s14w400clWhite.copyWith(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.82),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (buttonLabel != null) ...[
                        const SizedBox(height: 8),
                        _CtaButton(label: buttonLabel, textStyles: textStyles),
                      ],
                    ],

                    if (!compact) const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color.fromARGB(255, 216, 217, 219),
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.textLightGrey,
      size: 32,
    ),
  );
}

class _CtaButton extends StatelessWidget {
  final String label;
  final AppTextStyles textStyles;
  final bool compact;

  const _CtaButton({
    required this.label,
    required this.textStyles,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.alibabaOrange, Color(0xFFFF8A3D)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.alibabaOrange.withValues(alpha: 0.35),
            blurRadius: compact ? 6 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyles.s14w400clWhite.copyWith(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: compact ? 12 : 13,
          ),
        ],
      ),
    );
  }
}
