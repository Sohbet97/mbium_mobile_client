import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PersonRepository repository;
  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<CreateNewUserEvent>(_onCreateNewUser);
  }

  FutureOr<void> _onCreateNewUser(
    CreateNewUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(CreateNewUserProgress());
    try {
      final result = await repository.createNewUser(
        phoneNumber: event.phone,
        password: event.password,
        name: event.name,
        surName: event.sureName,
        email: event.email,
        birthday: event.birthday,
      );
    } catch (e) {
      emit(CreateNewUserError());
    }
  }
}
