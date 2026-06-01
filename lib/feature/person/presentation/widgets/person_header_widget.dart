import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import '../../../../generated/l10n.dart';

class PersonHeaderWidget extends StatelessWidget {
  const PersonHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        final person = state.personModel;
        final name = person?.name ?? '';
        final avatar = person?.avatar;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.navWhite,
                backgroundImage: avatar != null && avatar.isNotEmpty
                    ? NetworkImage(avatar)
                    : null,
                child: avatar == null || avatar.isEmpty
                    ? SvgPicture.asset(
                        'assets/icons/profil.svg',
                        width: 48,
                        height: 48,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : '',
                      style: textStyles.s16w600clBlack,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LB',
                            style: TextStyle(
                              color: AppColors.navWhite,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline,
                            size: 14,
                            color: AppColors.lightTextSecondary),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.navBarGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/icons/qr-code.svg',
                  width: 22,
                  height: 22,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}