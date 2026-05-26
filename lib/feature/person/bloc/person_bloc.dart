import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';

import '../models/person_model.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;
  PersonBloc({required this.repository}) : super(PersonState()) {
    on<IsRegisteredEvent>(_onIsRegistered);
    on<RegisterWithGostEvent>(_onRegisterWithGost);
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
    repository.preferences.saveRegistrationStatus(true);
    repository.preferences.saveGostUser(true);
    emit(
      state.copyWith(isRegistered: true, personModel: null, isGostUser: true),
    );
  }
}
