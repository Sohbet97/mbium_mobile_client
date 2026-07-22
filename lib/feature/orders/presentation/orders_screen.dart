import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/constants/my_error_widget.dart';
import 'package:mbium_mobile_client/core/network/interceptors.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/feature/orders/bloc/order_bloc.dart';
import 'package:mbium_mobile_client/feature/orders/model/order_model.dart';

import '../../../generated/l10n.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const LoadOrdersEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrderBloc>().add(LoadMoreOrdersEvent());
    }
  }

  Future<void> _confirmCancel(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sargydy ýatyrmak?'),
        content: const Text('Bu sargydy ýatyrmak isleýäňizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Ýok'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hawa', style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<OrderBloc>().add(CancelOrderEvent(id));
    }
  }

  void _showDetail(OrderModel order) {
    context.read<OrderBloc>().add(LoadOrderDetailEvent(order.id));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<OrderBloc>(),
        child: _OrderDetailSheet(orderId: order.id, fallback: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).menin_sargytlarym)),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            showGlobalMessage(state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is OrderLoading || state is OrderInitial) {
            return const MyLoadingWidget();
          }
          if (state is OrderError) {
            return MyErrorWidget(
              error: state.errorMessage,
              onTap: () =>
                  context.read<OrderBloc>().add(const LoadOrdersEvent()),
            );
          }

          final loaded = state as OrderLoaded;
          if (loaded.orders.isEmpty) {
            return const MyEmptyWidget(
              emptyText: 'Sargytlaryňyz heniz ýok',
              icon: Icons.receipt_long_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<OrderBloc>().add(const LoadOrdersEvent()),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: loaded.orders.length + (loaded.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= loaded.orders.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final order = loaded.orders[index];
                return _OrderCard(
                  order: order,
                  onTap: () => _showDetail(order),
                  onCancel: () => _confirmCancel(order.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onTap,
    required this.onCancel,
  });

  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final dateStr = order.createdAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt!.toLocal())
        : '';
    final itemsSummary = order.items.isNotEmpty
        ? order.items.map((i) => '${i.productName} x${i.quantity}').join(', ')
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Sargyt №${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    // NOTE: order.status codes aren't confirmed against a real
                    // status table yet — showing the raw code until we have
                    // one to map against.
                    'Ýagdaý: ${order.status}',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (dateStr.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12),
              ),
            ],
            const SizedBox(height: 8),
            if (itemsSummary != null)
              Text(
                itemsSummary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.lightTextSecondary),
              ),
            const SizedBox(height: 4),
            Text(
              order.deliveryAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.totalPrice.toStringAsFixed(2)} ${order.currency}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
                  child: const Text('Ýatyrmak'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderDetailSheet extends StatelessWidget {
  const _OrderDetailSheet({required this.orderId, required this.fallback});

  final int orderId;
  final OrderModel fallback;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final loaded = state is OrderLoaded ? state : null;
        final order =
            (loaded?.selectedOrder?.id == orderId ? loaded!.selectedOrder : null) ??
                fallback;
        final isLoading = loaded?.isLoadingDetail ?? false;

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textLightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sargyt №${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(order.deliveryAddress),
                  if (order.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Bellik: ${order.note}',
                      style: TextStyle(color: AppColors.lightTextSecondary),
                    ),
                  ],
                  const Divider(height: 24),
                  if (isLoading && order.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.productName)),
                            Text(
                              'x${item.quantity}',
                              style: TextStyle(color: AppColors.lightTextSecondary),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${item.totalPrice.toStringAsFixed(2)} ${order.currency}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Jemi', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text(
                        '${order.totalPrice.toStringAsFixed(2)} ${order.currency}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
