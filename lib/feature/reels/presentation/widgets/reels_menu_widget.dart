import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReelsMenuWidget extends StatelessWidget {
  const ReelsMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final localization = S.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          top: topPadding + 65,
          right: 16,
          left: 50,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),

                _buildMenuTile(
                  icon: Icon(
                    Icons.heart_broken_outlined,
                    color: Colors.black,
                    size: 28,
                  ),
                  title: localization.udalit_et,
                  subtitle: localization.posty_udalit_et,
                  onTap: () {},
                ),
                const Divider(
                  height: 1,
                  color: Colors.black12,
                  indent: 16,
                  endIndent: 16,
                ),

                _buildMenuTile(
                  icon: Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.black,
                    size: 28,
                  ),
                  title: localization.akkaundy_blokla,
                  subtitle: localization.sul_akkaunda_degisli_wideo_gorkezme,
                  onTap: () {},
                ),
                const Divider(
                  height: 1,
                  color: Colors.black12,
                  indent: 16,
                  endIndent: 16,
                ),

                _buildMenuTile(
                  icon: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                  title: localization.profile_arza_et,
                  subtitle: localization.Men_sul_akkauntdan_narazy,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required Icon icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.black54, fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}
