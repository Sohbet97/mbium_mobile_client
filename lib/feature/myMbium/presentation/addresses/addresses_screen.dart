import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/constants/my_error_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/bloc/address_bloc.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/addresses/widgets/address_card.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/addresses/widgets/address_form_sheet.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/feature/person/presentation/login_in_screen.dart';

import '../../../../generated/l10n.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddressesEvent());
  }

  void _confirmDelete(int id) {
    final localization = S.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localization.address_delete_title),
        content: Text(localization.address_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localization.address_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AddressBloc>().add(DeleteAddressEvent(id));
            },
            child: Text(
              localization.address_delete_action,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final isRegistered = context.read<PersonBloc>().state.personModel == null;

    if (isRegistered != false) {
      return const LoginInScreen();
    }

    return Scaffold(
      appBar: AppBar(title: Text(localization.addresses)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddressFormSheet.show(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state is AddressError) {
            return MyErrorWidget(error: state.errorMessage);
          }
          if (state is AddressLoading || state is AddressInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final addresses = state is AddressLoaded ? state.addresses : const [];

          if (addresses.isEmpty) {
            return MyEmptyWidget(
              emptyText: localization.addresses_empty,
              buttonText: localization.address_add,
              icon: Icons.location_on_outlined,
              onTap: () => AddressFormSheet.show(context),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return AddressCard(
                address: address,
                onEdit: () => AddressFormSheet.show(context, initial: address),
                onDelete: () => _confirmDelete(address.id),
              );
            },
          );
        },
      ),
    );
  }
}
