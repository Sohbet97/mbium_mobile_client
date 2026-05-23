import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;
  CategoryBloc({required this.repository}) : super(CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  FutureOr<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(LoadCategoriesProgress());
    try {
      final result = await repository.getCategories(event.isRefresh);
      emit(LoadCategoriesSuccess(categories: result));
    } catch (e) {
      emit(LoadCategoriesError(errorMessage: e.toString()));
    }
  }
}
