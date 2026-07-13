part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

final class LoadOrdersEvent extends OrderEvent {
  final OrderFilter filter;

  const LoadOrdersEvent({this.filter = const OrderFilter()});

  @override
  List<Object?> get props => [filter];
}

final class LoadMoreOrdersEvent extends OrderEvent {}

final class LoadOrderDetailEvent extends OrderEvent {
  final int id;

  const LoadOrderDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

final class CreateOrdersEvent extends OrderEvent {
  final Map<String, dynamic> payload;

  const CreateOrdersEvent(this.payload);

  @override
  List<Object?> get props => [payload];
}

final class CancelOrderEvent extends OrderEvent {
  final int id;
  final String? note;

  const CancelOrderEvent(this.id, {this.note});

  @override
  List<Object?> get props => [id, note];
}
