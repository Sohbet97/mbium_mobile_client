import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
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

          return SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(loc.profil, style: context.appTextStyles.s16w600clBlack),
                  centerTitle: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        ProfileHeaderWidget(
                          avatarUrl: person.avatar,
                          displayName: fullName.isNotEmpty ? fullName : person.email,
                        ),
                        const SizedBox(height: 20),
                        ProfileInfoCardWidget(
                          fullName: fullName,
                          email: person.email,
                        ),
                        const SizedBox(height: 24),
                        const ProfileConnectedAccountsWidget(),
                        const SizedBox(height: 24),
                        const ProfilePreferencesCardWidget(),
                        const SizedBox(height: 28),
                        _LogoutButton(
                          label: loc.log_out,
                          onTap: () => _onLogOut(context),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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