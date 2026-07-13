import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/orders/data/order_repository.dart';
import 'package:mbium_mobile_client/feature/orders/model/order_filter.dart';
import 'package:mbium_mobile_client/feature/orders/model/order_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<LoadOrdersEvent>(_onLoad);
    on<LoadMoreOrdersEvent>(_onLoadMore);
    on<LoadOrderDetailEvent>(_onLoadDetail);
    on<CreateOrdersEvent>(_onCreate);
    on<CancelOrderEvent>(_onCancel);
  }

  FutureOr<void> _onLoad(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final result = await repository.getOrders(event.filter);
      emit(
        OrderLoaded(
          orders: result.orders,
          count: result.count,
          filter: event.filter,
          hasMore: result.orders.length < result.count,
        ),
      );
    } catch (e) {
      emit(OrderError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onLoadMore(
    LoadMoreOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    final current = state;
    if (current is! OrderLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextFilter = current.filter.nextPage();
      final result = await repository.getOrders(nextFilter);
      emit(
        current.copyWith(
          orders: [...current.orders, ...result.orders],
          count: result.count,
          filter: nextFilter,
          isLoadingMore: false,
          hasMore:
              (current.orders.length + result.orders.length) < result.count,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  FutureOr<void> _onLoadDetail(
    LoadOrderDetailEvent event,
    Emitter<OrderState> emit,
  ) async {
    final current = state;
    if (current is! OrderLoaded) return;

    emit(current.copyWith(isLoadingDetail: true));
    try {
      final order = await repository.getOrder(event.id);
      emit(current.copyWith(selectedOrder: order, isLoadingDetail: false));
    } catch (e) {
      emit(current.copyWith(isLoadingDetail: false));
    }
  }

  FutureOr<void> _onCreate(
    CreateOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    final current = state;
    try {
      final created = await repository.createOrders(event.payload);
      if (current is OrderLoaded) {
        emit(
          current.copyWith(
            orders: [...created, ...current.orders],
            count: current.count + created.length,
          ),
        );
      }
    } catch (e) {
      emit(OrderError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onCancel(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    final current = state;
    if (current is! OrderLoaded) return;

    emit(current.copyWith(isCancelling: true));
    try {
      await repository.cancelOrder(event.id, note: event.note);
      final refreshed = await repository.getOrder(event.id);
      final orders = current.orders
          .map((o) => o.id == event.id ? refreshed : o)
          .toList();
      emit(
        current.copyWith(
          orders: orders,
          isCancelling: false,
          selectedOrder: current.selectedOrder?.id == event.id
              ? refreshed
              : current.selectedOrder,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isCancelling: false));
    }
  }
}
