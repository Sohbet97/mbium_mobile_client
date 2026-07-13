part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderError extends OrderState {
  final String errorMessage;

  const OrderError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  final int count;
  final OrderFilter filter;
  final bool hasMore;
  final bool isLoadingMore;
  final OrderModel? selectedOrder;
  final bool isLoadingDetail;
  final bool isCancelling;

  const OrderLoaded({
    required this.orders,
    required this.count,
    required this.filter,
    required this.hasMore,
    this.isLoadingMore = false,
    this.selectedOrder,
    this.isLoadingDetail = false,
    this.isCancelling = false,
  });

  OrderLoaded copyWith({
    List<OrderModel>? orders,
    int? count,
    OrderFilter? filter,
    bool? hasMore,
    bool? isLoadingMore,
    OrderModel? selectedOrder,
    bool clearSelectedOrder = false,
    bool? isLoadingDetail,
    bool? isCancelling,
  }) {
    return OrderLoaded(
      orders: orders ?? this.orders,
      count: count ?? this.count,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedOrder: clearSelectedOrder
          ? null
          : (selectedOrder ?? this.selectedOrder),
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isCancelling: isCancelling ?? this.isCancelling,
    );
  }

  @override
  List<Object?> get props => [
    orders,
    count,
    filter,
    hasMore,
    isLoadingMore,
    selectedOrder,
    isLoadingDetail,
    isCancelling,
  ];
}
