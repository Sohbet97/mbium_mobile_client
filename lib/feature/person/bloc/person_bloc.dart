import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository repository;
  PersonBloc({required this.repository}) : super(PersonInitial()) {
    on<PersonEvent>((event, emit) {});
  }
}
