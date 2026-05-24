part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

final class LoadCategoriesEvent extends CategoryEvent {
  final bool? isRefresh;

  const LoadCategoriesEvent({required this.isRefresh});
}
