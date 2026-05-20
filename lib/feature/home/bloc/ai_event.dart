part of 'ai_bloc.dart';

sealed class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object> get props => [];
}

final class GetRecomendasionListEvent extends AiEvent {}
