import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_history_bloc.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_history_model.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_topup_model.dart';
import 'package:mbium_mobile_client/feature/cupons/presentation/widgets/coin_widgets.dart';

import '../../../generated/l10n.dart';

/// Coin activity screen: transaction history + top-up requests, reached from
/// the history icon on [MyCuponsScreen]'s AppBar. Expects a [CoinHistoryBloc]
/// to already be provided above it — the caller passes in the same instance
/// [MyCuponsScreen] already loaded, so data isn't re-fetched on open.
class CoinHistoryScreen extends StatefulWidget {
  const CoinHistoryScreen({super.key});

  @override
  State<CoinHistoryScreen> createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _historyScrollController = ScrollController();
  final _topupScrollController = ScrollController();

  final List<CoinHistoryModel> _history = [];
  final List<CoinTopupModel> _topups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _historyScrollController.addListener(() {
      if (_historyScrollController.position.pixels >=
          _historyScrollController.position.maxScrollExtent - 200) {
        context.read<CoinHistoryBloc>().add(const LoadMoreCoinHistoryEvent());
      }
    });
    _topupScrollController.addListener(() {
      if (_topupScrollController.position.pixels >=
          _topupScrollController.position.maxScrollExtent - 200) {
        context.read<CoinHistoryBloc>().add(const LoadMoreCoinTopupsEvent());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _historyScrollController.dispose();
    _topupScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.coin_history_tab),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryGreen,
          tabs: [
            Tab(text: loc.coin_history_tab),
            Tab(text: loc.coin_topup_tab),
          ],
        ),
      ),
      body: BlocConsumer<CoinHistoryBloc, CoinHistoryState>(
        listener: (context, state) {
          if (state is CoinHistoryLoading) {
            _history.clear();
          }
          if (state is CoinHistoryLoaded) {
            _history
              ..clear()
              ..addAll(state.items);
          }
          if (state is CoinHistoryError) {
            MyHelpers.showMessage(
              loc.nasazlyk_yuze_cykdy,
              AppColors.errorRed,
              context,
            );
          }
          if (state is CoinTopupsLoading) {
            _topups.clear();
          }
          if (state is CoinTopupsLoaded) {
            _topups
              ..clear()
              ..addAll(state.items);
          }
          if (state is CoinTopupsError) {
            MyHelpers.showMessage(
              loc.nasazlyk_yuze_cykdy,
              AppColors.errorRed,
              context,
            );
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [_buildHistoryTab(state), _buildTopupsTab(state)],
          );
        },
      ),
    );
  }

  Widget _buildHistoryTab(CoinHistoryState state) {
    final loc = S.of(context);
    final isInitialLoading = state is CoinHistoryLoading && _history.isEmpty;
    final isLoadingMore = state is CoinHistoryLoaded && state.isLoadingMore;

    if (isInitialLoading) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 6,
        itemBuilder: (_, _) => const CoinTileShimmer(),
      );
    }

    if (_history.isEmpty) {
      return Center(child: MyEmptyWidget(emptyText: loc.coin_history_empty));
    }

    return ListView.builder(
      controller: _historyScrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _history.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _history.length) {
          return CoinHistoryTile(item: _history[index]);
        }
        return const CoinTileShimmer();
      },
    );
  }

  Widget _buildTopupsTab(CoinHistoryState state) {
    final loc = S.of(context);
    final isInitialLoading = state is CoinTopupsLoading && _topups.isEmpty;
    final isLoadingMore = state is CoinTopupsLoaded && state.isLoadingMore;

    if (isInitialLoading) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 6,
        itemBuilder: (_, _) => const CoinTileShimmer(),
      );
    }

    if (_topups.isEmpty) {
      return Center(child: MyEmptyWidget(emptyText: loc.coin_topup_empty));
    }

    return ListView.builder(
      controller: _topupScrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _topups.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _topups.length) {
          return CoinTopupTile(item: _topups[index]);
        }
        return const CoinTileShimmer();
      },
    );
  }
}
