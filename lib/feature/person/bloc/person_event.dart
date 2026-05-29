part of 'person_bloc.dart';

sealed class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

final class IsRegisteredEvent extends PersonEvent {}

final class RegisterWithGostEvent extends PersonEvent {}

final class SignInWithGoogleEvent extends PersonEvent {}

final class SignOutEvent extends PersonEvent {}

final class CreateNewUserEvent extends PersonEvent {
  final String name;
  final String sureName;
  final String? email;
  final String password;
  final String phone;
  final DateTime? birthday;

  const CreateNewUserEvent({
    required this.name,
    required this.sureName,
    required this.email,
    required this.password,
    required this.birthday,
    required this.phone,
  });
}
