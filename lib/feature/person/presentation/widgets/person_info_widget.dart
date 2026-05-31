import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import '../../../../generated/l10n.dart';

class PersonInfoWidget extends StatelessWidget {
  const PersonInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocBuilder<PersonBloc, PersonState>(
      builder: (context, state) {
        final person = state.personModel;

        final items = [
        _InfoItem(label: l10n.doly_ady, value: 'Gurbanmyrat Tashliyev'),
        _InfoItem(label: l10n.elektron_poctasy, value: 'gurbanmyrat.t****@gmail.com'),
        _InfoItem(label: l10n.telefon_belgisi, value: '+993 61 234567'),
        _InfoItem(label: l10n.paroly_uytget, value: ''),
      ];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.value.isNotEmpty)
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.lightTextSecondary),
                      ],
                    ),
                    onTap: () {},
                  ),
                  if (i < items.length - 1)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});
}