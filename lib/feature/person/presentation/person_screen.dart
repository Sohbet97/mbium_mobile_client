import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_bloc.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/feature/person/models/person_model.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/profile_connected_accounts_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/profile_header_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/profile_info_card_widget.dart';
import 'package:mbium_mobile_client/feature/person/presentation/widgets/profile_preferences_card_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          return _PersonAccountView(
            person: person,
            fullName: fullName,
            onLogOut: () => _onLogOut(context),
          );
        },
      ),
    );
  }
}

class _PersonAccountView extends StatelessWidget {
  const _PersonAccountView({
    required this.person,
    required this.fullName,
    required this.onLogOut,
  });

  final PersonModel person;
  final String fullName;
  final VoidCallback onLogOut;

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 56),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryGreen, AppColors.deepForest],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          Expanded(
                            child: Text(
                              loc.profil,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, '/settings'),
                            icon: const Icon(Icons.settings_outlined, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ProfileHeaderWidget(
                        avatarUrl: person.avatar,
                        displayName: fullName.isNotEmpty ? fullName : person.email,
                        subtitle: fullName.isNotEmpty ? person.email : null,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: -36,
                child: const _QuickStatsCard(),
              ),
            ],
          ),
          const SizedBox(height: 58),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _OrdersQuickAccessCard(),
                const SizedBox(height: 24),
                Text(loc.ayratynlyklar, style: context.appTextStyles.s16w600clBlack),
                const SizedBox(height: 12),
                const _FunctionsGrid(),
                const SizedBox(height: 24),
                ProfileInfoCardWidget(
                  fullName: fullName,
                  email: person.email,
                ),
                const SizedBox(height: 24),
                const ProfileConnectedAccountsWidget(),
                const SizedBox(height: 24),
                const ProfilePreferencesCardWidget(),
                const SizedBox(height: 28),
                _LogoutButton(label: loc.log_out, onTap: onLogOut),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatsCard extends StatelessWidget {
  const _QuickStatsCard();

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<CoinBloc, CoinState>(
              builder: (context, state) {
                final balance = state is CoinLoaded ? state.coin.balance : null;
                return _StatItem(
                  icon: Icons.account_balance_wallet_outlined,
                  value: balance != null ? balance.toStringAsFixed(0) : '—',
                  label: loc.balance,
                  onTap: () => Navigator.pushNamed(context, '/balance'),
                );
              },
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.confirmation_number_outlined,
              value: null,
              label: loc.hasabym,
              onTap: () => Navigator.pushNamed(context, '/cupons'),
            ),
          ),
          _StatDivider(),
          Expanded(
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                final count = state is FavoriteLoaded ? state.favorites.length : 0;
                return _StatItem(
                  icon: Icons.favorite_border,
                  value: count > 0 ? count.toString() : null,
                  label: loc.favorites,
                  onTap: () => Navigator.pushNamed(context, '/favorite'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: Colors.grey.withValues(alpha: 0.2),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String? value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(height: 6),
          Text(
            value ?? label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          if (value != null) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrdersQuickAccessCard extends StatelessWidget {
  const _OrdersQuickAccessCard();

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pushNamed(context, '/orders'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(loc.menin_sargytlarym, style: context.appTextStyles.s16w600clBlack),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        loc.hemmesi,
                        style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
                      ),
                      Icon(Icons.chevron_right, size: 18, color: Colors.grey.withValues(alpha: 0.6)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _OrderStageItem(
                icon: Icons.payment_outlined,
                label: loc.order_to_pay,
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              _OrderStageItem(
                icon: Icons.inventory_2_outlined,
                label: loc.order_to_ship,
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              _OrderStageItem(
                icon: Icons.local_shipping_outlined,
                label: loc.order_to_receive,
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              _OrderStageItem(
                icon: Icons.rate_review_outlined,
                label: loc.order_to_review,
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              _OrderStageItem(
                icon: Icons.assignment_return_outlined,
                label: loc.order_after_sale,
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderStageItem extends StatelessWidget {
  const _OrderStageItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: AppColors.lightTextPrimary),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.5, color: AppColors.lightTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _FunctionsGrid extends StatelessWidget {
  const _FunctionsGrid();

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    final items = <_GridMenuItem>[
      _GridMenuItem(icon: Icons.location_on_outlined, label: loc.addresses, route: '/addresses'),
      _GridMenuItem(icon: Icons.history, label: loc.history, route: '/review'),
      _GridMenuItem(icon: Icons.receipt_long_outlined, label: loc.tolegler, route: '/tolegler'),
      _GridMenuItem(icon: Icons.category_outlined, label: loc.categories, route: '/categories'),
      _GridMenuItem(icon: Icons.storefront_outlined, label: loc.mbiumda_satyp_basla, route: '/reg_shop'),
      _GridMenuItem(icon: Icons.smart_toy_outlined, label: loc.podpiska, route: '/aiPodpiska'),
      _GridMenuItem(icon: Icons.support_agent_outlined, label: loc.support, route: '/support'),
      _GridMenuItem(icon: Icons.gavel_outlined, label: loc.ulanys_duzgunleri, route: '/duzgunler'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 4,
          childAspectRatio: 0.82,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return InkWell(
            onTap: () => Navigator.pushNamed(context, item.route),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: AppColors.primaryGreen, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GridMenuItem {
  const _GridMenuItem({required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;
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
