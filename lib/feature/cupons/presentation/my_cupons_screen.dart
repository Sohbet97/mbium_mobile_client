import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_bloc.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_history_bloc.dart';
import 'package:mbium_mobile_client/feature/cupons/data/coin_repository.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_history_model.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_topup_model.dart';
import 'package:mbium_mobile_client/feature/cupons/presentation/widgets/coin_widgets.dart';

import '../../../generated/l10n.dart';

class MyCuponsScreen extends StatefulWidget {
  const MyCuponsScreen({super.key});

  @override
  State<MyCuponsScreen> createState() => _MyCuponsScreenState();
}

class _MyCuponsScreenState extends State<MyCuponsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final CoinHistoryBloc _coinHistoryBloc;

  final _historyScrollController = ScrollController();
  final _topupScrollController = ScrollController();

  final List<CoinHistoryModel> _history = [];
  final List<CoinTopupModel> _topups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _coinHistoryBloc =
        CoinHistoryBloc(repository: context.read<CoinRepository>())
          ..add(const LoadCoinHistoryEvent())
          ..add(const LoadCoinTopupsEvent());

    _historyScrollController.addListener(() {
      if (_historyScrollController.position.pixels >=
          _historyScrollController.position.maxScrollExtent - 200) {
        _coinHistoryBloc.add(const LoadMoreCoinHistoryEvent());
      }
    });
    _topupScrollController.addListener(() {
      if (_topupScrollController.position.pixels >=
          _topupScrollController.position.maxScrollExtent - 200) {
        _coinHistoryBloc.add(const LoadMoreCoinTopupsEvent());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _historyScrollController.dispose();
    _topupScrollController.dispose();
    _coinHistoryBloc.close();
    super.dispose();
  }

  void _openTopUpSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: BlocProvider.value(
            value: _coinHistoryBloc,
            child: BlocConsumer<CoinHistoryBloc, CoinHistoryState>(
              listener: (context, state) {
                final loc = S.of(context);
                if (state is CoinTopupSubmitSuccess) {
                  Navigator.pop(sheetContext);
                  MyHelpers.showMessage(
                    loc.coin_topup_success,
                    AppColors.successGreen,
                    context,
                  );
                  _coinHistoryBloc.add(const LoadCoinTopupsEvent());
                }
                if (state is CoinTopupSubmitError) {
                  MyHelpers.showMessage(
                    state.message,
                    AppColors.errorRed,
                    context,
                  );
                }
              },
              builder: (context, state) {
                return CoinTopupSheet(
                  isSubmitting: state is CoinTopupSubmitting,
                  onSubmit: (amountTmt, receiptUrl) {
                    _coinHistoryBloc.add(
                      SubmitCoinTopupEvent(
                        amountTmt: amountTmt,
                        receiptUrl: receiptUrl,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      body: BlocListener<CoinHistoryBloc, CoinHistoryState>(
        bloc: _coinHistoryBloc,
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
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: BlocBuilder<CoinBloc, CoinState>(
                  builder: (context, coinState) {
                    return CoinBalanceHeader(
                      balance: coinState is CoinLoaded
                          ? coinState.coin.balance
                          : null,
                      isLoading:
                          coinState is CoinLoading || coinState is CoinInitial,
                      onTopUp: _openTopUpSheet,
                    );
                  },
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
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
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              BlocBuilder<CoinHistoryBloc, CoinHistoryState>(
                bloc: _coinHistoryBloc,
                builder: (context, state) {
                  final isInitialLoading =
                      state is CoinHistoryLoading && _history.isEmpty;
                  final isLoadingMore =
                      state is CoinHistoryLoaded && state.isLoadingMore;

                  context.read<CoinBloc>().add(LoadCoinBalanceEvent());

                  if (isInitialLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: 6,
                      itemBuilder: (_, _) => const CoinTileShimmer(),
                    );
                  }

                  if (_history.isEmpty) {
                    return Center(
                      child: MyEmptyWidget(emptyText: loc.coin_history_empty),
                    );
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
                },
              ),
              BlocBuilder<CoinHistoryBloc, CoinHistoryState>(
                bloc: _coinHistoryBloc,
                builder: (context, state) {
                  final isInitialLoading =
                      state is CoinTopupsLoading && _topups.isEmpty;
                  final isLoadingMore =
                      state is CoinTopupsLoaded && state.isLoadingMore;

                  if (isInitialLoading) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: 6,
                      itemBuilder: (_, _) => const CoinTileShimmer(),
                    );
                  }

                  if (_topups.isEmpty) {
                    return Center(
                      child: MyEmptyWidget(emptyText: loc.coin_topup_empty),
                    );
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}
