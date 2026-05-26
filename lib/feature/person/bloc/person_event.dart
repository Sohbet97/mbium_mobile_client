part of 'person_bloc.dart';

sealed class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

final class IsRegisteredEvent extends PersonEvent {}

final class RegisterWithGostEvent extends PersonEvent {}
