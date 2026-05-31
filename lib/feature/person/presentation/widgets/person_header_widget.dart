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
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        final person = state.personModel;
        final name = person?.name ?? '';
        final avatar = person?.avatar;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
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
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 14),
                    const SizedBox(width: 4),
                    Text(l10n.alyyjy_gornushi,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.navWhite,
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