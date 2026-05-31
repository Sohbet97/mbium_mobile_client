import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';

import '../models/person_model.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;

  PersonBloc({required this.repository}) : super(const PersonState()) {
    on<IsRegisteredEvent>(_onIsRegistered);
    on<RegisterWithGostEvent>(_onRegisterWithGost);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<LogOutEvent>(_logOut);
  }

  FutureOr<void> _onIsRegistered(
    IsRegisteredEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      final result = await repository.preferences.isRegistered();
      final isGost = await repository.preferences.isGostUser();
      emit(state.copyWith(isRegistered: result, isGostUser: isGost));
    } catch (e) {
      emit(state.copyWith(errorMessage: '$e'));
    }
  }

  FutureOr<void> _onRegisterWithGost(
    RegisterWithGostEvent event,
    Emitter<PersonState> emit,
  ) async {
    await repository.preferences.saveRegistrationStatus(true);
    await repository.preferences.saveGostUser(true);
    emit(
      state.copyWith(isRegistered: true, personModel: null, isGostUser: true),
    );
  }

  FutureOr<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final person = await repository.signInWithGoogle();
      emit(
        state.copyWith(
          isLoading: false,
          isRegistered: true,
          isGostUser: false,
          personModel: person,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  FutureOr<void> _onSignOut(
    SignOutEvent event,
    Emitter<PersonState> emit,
  ) async {
    await repository.signOut();
    emit(const PersonState());
  }

  FutureOr<void> _logOut(LogOutEvent event, Emitter<PersonState> emit) async {
    await repository.preferences.clearAll();
    emit(
      state.copyWith(
        isGostUser: false,
        isLoading: false,
        isRegistered: false,
        personModel: null,
        errorMessage: null,
      ),
    );
  }
}
