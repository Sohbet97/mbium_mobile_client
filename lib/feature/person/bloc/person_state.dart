part of 'person_bloc.dart';

sealed class PersonState extends Equatable {
  const PersonState();
  
  @override
  List<Object> get props => [];
}

final class PersonInitial extends PersonState {}
