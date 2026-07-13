part of 'address_bloc.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressError extends AddressState {
  final String errorMessage;

  const AddressError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;

  const AddressLoaded({required this.addresses});

  AddressLoaded copyWith({List<AddressModel>? addresses}) {
    return AddressLoaded(addresses: addresses ?? this.addresses);
  }

  @override
  List<Object> get props => [addresses];
}
