import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_model.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final Dio dio;
  List<CollectionModel>? _collections;
  CollectionBloc({required this.dio}) : super(CollectionInitial()) {
    on<CollectionEvent>((event, emit) async {
      if (event is LoadAllCollectionEvent) {
        emit(LoadAllCollectionsProgress());

        if (_collections != null) {
          emit(LoadAllCollectionsSuccess(collections: _collections!));
          return;
        }

        try {
          final response = await dio.get('/catalog/collections');

          if (response.statusCode != 200) {
            throw Exception('status code: ${response.statusCode}');
          }

          // _collections = (response.data['data'] as List).map((item) => )
          emit(LoadAllCollectionsSuccess(collections: []));
        } catch (e) {
          emit(LoadAllCollectionsError(errorMessage: e.toString()));
        }
      }
    });
  }
}
