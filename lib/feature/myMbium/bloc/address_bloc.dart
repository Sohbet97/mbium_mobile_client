import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/myMbium/data/address_repository.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/address_model.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository repository;

  AddressBloc({required this.repository}) : super(AddressInitial()) {
    on<LoadAddressesEvent>(_onLoad);
    on<AddAddressEvent>(_onAdd);
    on<UpdateAddressEvent>(_onUpdate);
    on<DeleteAddressEvent>(_onDelete);
  }

  FutureOr<void> _onLoad(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await repository.getAddresses();
      emit(AddressLoaded(addresses: addresses));
    } catch (e) {
      emit(AddressError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onAdd(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final current = state;
    if (current is! AddressLoaded) return;
    try {
      final created = await repository.createAddress(event.address);
      emit(current.copyWith(addresses: [...current.addresses, created]));
    } catch (e) {
      emit(AddressError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onUpdate(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final current = state;
    if (current is! AddressLoaded) return;
    try {
      await repository.updateAddress(event.id, event.address);
      final addresses = current.addresses
          .map(
            (a) => a.id == event.id
                ? event.address.copyWith(
                    id: a.id,
                    userId: a.userId,
                    createdAt: a.createdAt,
                  )
                : a,
          )
          .toList();
      emit(current.copyWith(addresses: addresses));
    } catch (e) {
      emit(AddressError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onDelete(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final current = state;
    if (current is! AddressLoaded) return;
    try {
      await repository.deleteAddress(event.id);
      emit(
        current.copyWith(
          addresses: current.addresses.where((a) => a.id != event.id).toList(),
        ),
      );
    } catch (e) {
      emit(AddressError(errorMessage: e.toString()));
    }
  }
}
