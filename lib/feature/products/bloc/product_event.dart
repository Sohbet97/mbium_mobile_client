part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Загрузить с новым фильтром (сбрасывает список)
final class LoadProducts extends ProductEvent {
  final FilterModel filter;

  const LoadProducts(this.filter);

  @override
  List<Object?> get props => [filter];
}

// Подгрузить следующую страницу
final class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

// Перезагрузить с тем же фильтром
final class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}
