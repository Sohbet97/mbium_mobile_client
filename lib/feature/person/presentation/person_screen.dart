import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_bloc.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

/// Alibaba-style "Account" detail page — reached by tapping the profile
/// header on [MyMbiumPage] or the "Profil" row in [SettingsScreen]. Focused
/// on identity + account-management rows (addresses, verification, support,
/// settings, logout); deliberately doesn't repeat [MyMbiumPage]'s commerce
/// menu grid (favorites/coupons/history/balance shortcut), so the two
/// screens stay complementary instead of duplicating each other.
class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  Future<void> _onLogOut(BuildContext context) async {
    final loc = S.of(context);
    final result = await MyHelpers.showAlertDialog(
      context,
      loc.log_out,
      loc.log_out_desc,
      Icons.exit_to_app,
      AppColors.errorRed,
    );

    if (result == true && context.mounted) {
      context.read<PersonBloc>().add(LogOutEvent());
      MyHelpers.showMessage(
        loc.ulgamdan_cykdynyz,
        AppColors.primaryGreen,
        context,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: BlocBuilder<PersonBloc, PersonState>(
        builder: (context, state) {
          final person = state.personModel;

          if (person == null && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (person == null) {
            return _GuestView(loc: loc);
          }

          final fullName = [
            person.name,
            person.surname,
          ].where((part) => part != null && part.isNotEmpty).join(' ');

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 210,
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                title: Text(loc.profil),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.secondaryGreen,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 46),
                        child: Column(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: person.avatar != null
                                    ? Image.network(
                                        person.avatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) =>
                                            _avatarFallback(),
                                      )
                                    : _avatarFallback(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              fullName.isNotEmpty ? fullName : person.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              person.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _BalanceCard(),
                        const SizedBox(height: 16),
                        _MenuCard(loc: loc),
                        const SizedBox(height: 20),
                        _LogoutButton(
                          label: loc.log_out,
                          onTap: () => _onLogOut(context),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _avatarFallback() => Container(
    color: Colors.white24,
    child: const Icon(Icons.person, color: Colors.white, size: 44),
  );
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PremiumCard(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/balance'),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Image.asset(
                'assets/images/coin_image.png',
                height: 28,
                width: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BlocBuilder<CoinBloc, CoinState>(
                  builder: (context, coinState) {
                    final balance = coinState is CoinLoaded
                        ? coinState.coin.balance
                        : null;
                    return Text(
                      balance != null ? balance.toStringAsFixed(0) : '—',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    );
                  },
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.loc});

  final S loc;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.location_on_outlined,
        label: loc.addresses,
        route: '/addresses',
      ),
      _MenuItem(
        icon: Icons.verified_user_outlined,
        label: loc.tassyklama_tapgyrlary,
        route: '/verifyAccount',
      ),
      _MenuItem(
        icon: Icons.support_agent_outlined,
        label: loc.komek_seslenme,
        route: '/support',
      ),
      _MenuItem(
        icon: Icons.settings_outlined,
        label: loc.sazlamalar,
        route: '/settings',
      ),
    ];

    return _PremiumCard(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _MenuRow(item: items[i]),
            if (i != items.length - 1)
              Divider(
                height: 1,
                indent: 52,
                color: Colors.grey.withValues(alpha: 0.12),
              ),
          ],
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pushNamed(context, item.route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: AppColors.primaryGreen),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorRed,
          side: BorderSide(color: AppColors.errorRed.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.exit_to_app, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  const _PremiumCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _GuestView extends StatelessWidget {
  const _GuestView({required this.loc});

  final S loc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(loc.profil)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 44,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                loc.myhman,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.myhman_desc,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/loginIn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    loc.dowam_et,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
