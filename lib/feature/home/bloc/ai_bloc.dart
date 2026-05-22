import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/home/data/ai_repository.dart';
import 'package:mbium_mobile_client/feature/home/models/ai_recomendasion_model.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  final AiRepository repository;
  AiBloc({required this.repository}) : super(AiInitial()) {
    on<GetRecomendasionListEvent>(_onGetRecomendasion);
  }

  FutureOr<void> _onGetRecomendasion(
    GetRecomendasionListEvent event,
    Emitter<AiState> emit,
  ) async {
    emit(GetRecomendasionListProgress());
    try {
      final result = await repository.loadRecomendasionList();
      emit(GetRecomendasionListSuccess(models: result));
    } catch (e) {
      emit(GetRecomendasionListError(errorMessage: e.toString()));
    }
  }
}
