part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class CreateNewUserProgress extends AuthState {}

final class CreateNewUserError extends AuthState {}

final class CreateNewUserSuccess extends AuthState {
  final String sessionId;

  const CreateNewUserSuccess({required this.sessionId});
}
