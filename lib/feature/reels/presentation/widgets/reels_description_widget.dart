import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReelsDescriptionWidget extends StatefulWidget {
  const ReelsDescriptionWidget({super.key, required this.caption});

  final String caption;

  @override
  State<ReelsDescriptionWidget> createState() => _ReelsDescriptionWidgetState();
}

class _ReelsDescriptionWidgetState extends State<ReelsDescriptionWidget> {
  static const _style = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  bool _expanded = false;

  bool _overflows(double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: widget.caption, style: _style),
      maxLines: 2,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.caption.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final canExpand = !_expanded && _overflows(constraints.maxWidth);

        return GestureDetector(
          onTap: canExpand ? () => setState(() => _expanded = true) : null,
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.caption,
                style: _style,
                maxLines: _expanded ? null : 2,
                overflow: _expanded ? null : TextOverflow.ellipsis,
              ),
              if (canExpand)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    S.of(context).ahlisin_gorkez,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
