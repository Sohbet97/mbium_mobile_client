part of 'address_bloc.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

final class LoadAddressesEvent extends AddressEvent {}

final class AddAddressEvent extends AddressEvent {
  final AddressModel address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

final class UpdateAddressEvent extends AddressEvent {
  final int id;
  final AddressModel address;

  const UpdateAddressEvent(this.id, this.address);

  @override
  List<Object?> get props => [id, address];
}

final class DeleteAddressEvent extends AddressEvent {
  final int id;

  const DeleteAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}
