part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class LoadCategoriesProgress extends CategoryState {}

final class LoadCategoriesError extends CategoryState {
  final String errorMessage;

  const LoadCategoriesError({required this.errorMessage});
}

final class LoadCategoriesSuccess extends CategoryState {
  final List<CategoryModel> categories;

  const LoadCategoriesSuccess({required this.categories});

  @override
  List<Object> get props => [categories];
}
