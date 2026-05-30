part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class CreateNewUserEvent extends AuthEvent {
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
