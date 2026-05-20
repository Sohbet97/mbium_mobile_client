part of 'ai_bloc.dart';

sealed class AiState extends Equatable {
  const AiState();

  @override
  List<Object> get props => [];
}

final class AiInitial extends AiState {}

//
final class GetRecomendasionListProgress extends AiState {}

final class GetRecomendasionListError extends AiState {
  final String errorMessage;

  const GetRecomendasionListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class GetRecomendasionListSuccess extends AiState {
  final List<AiRecommendationModel> models;

  const GetRecomendasionListSuccess({required this.models});
  @override
  List<Object> get props => [models];
}
