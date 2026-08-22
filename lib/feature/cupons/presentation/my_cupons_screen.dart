import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/utils/FadeRouter.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_bloc.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_history_bloc.dart';
import 'package:mbium_mobile_client/feature/cupons/data/coin_repository.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_history_model.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_topup_model.dart';
import 'package:mbium_mobile_client/feature/cupons/presentation/coin_history_screen.dart';

import '../../../generated/l10n.dart';

enum _TopupMethod { cash, card }

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

    _selected = _balances[0];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _historyScrollController.dispose();
    _topupScrollController.dispose();
    _coinHistoryBloc.close();
    super.dispose();
  }

  Future<void> _openTopUpSheet() async {
    final method = await showDialog<_TopupMethod>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Töleg usuly'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, _TopupMethod.cash),
              child: Row(
                children: [
                  Icon(Icons.payments_outlined, color: AppColors.primaryGreen),
                  SizedBox(width: 12),
                  Text(S.of(context).nagt),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, _TopupMethod.card),
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: AppColors.primaryGreen),
                  SizedBox(width: 12),
                  Text(S.of(context).bank_karty),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (method == null || !mounted) return;

    if (method == _TopupMethod.card) {
      MyHelpers.showMessage(
        'Bank kartasy arkaly töleg entek elýeter däl',
        AppColors.errorRed,
        context,
      );
      return;
    }

    _coinHistoryBloc.add(
      SubmitCoinTopupEvent(amountTmt: _selected.tmtBalance, receiptUrl: ''),
    );
  }

  final _balances = <_CoinAddModel>[
    _CoinAddModel(balance: 50, tmtBalance: 5),
    _CoinAddModel(balance: 100, tmtBalance: 10),
    _CoinAddModel(balance: 200, tmtBalance: 20),
    _CoinAddModel(balance: 500, tmtBalance: 50),
    _CoinAddModel(balance: 1000, tmtBalance: 100),
    _CoinAddModel(balance: 1500, tmtBalance: 150),
    _CoinAddModel(balance: 2000, tmtBalance: 200),
    _CoinAddModel(balance: 10000, tmtBalance: 1000),
  ];

  late _CoinAddModel _selected;

  // User-entered custom amount — null until they fill it in via the dialog.
  // 10 coins = 1 TMT, matching the fixed ratio of every preset above.
  _CoinAddModel? _customModel;

  Future<void> _openCustomAmountDialog() async {
    final controller = TextEditingController(
      text: _customModel != null
          ? _customModel!.balance.toStringAsFixed(0)
          : '',
    );
    final loc = S.of(context);
    var tmt = (double.tryParse(controller.text) ?? 0) / 10;

    final coins = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(S.of(context).mukdary),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(suffixText: 'coin'),
                    onChanged: (value) {
                      final parsed = double.tryParse(value.trim()) ?? 0;
                      setDialogState(() => tmt = parsed / 10);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '≈ ${tmt.toStringAsFixed(2)} TMT',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(loc.address_cancel),
                ),
                TextButton(
                  onPressed: () {
                    final value = double.tryParse(controller.text.trim());
                    if (value != null && value > 0) {
                      Navigator.pop(dialogContext, value);
                    }
                  },
                  child: Text(loc.ugrat),
                ),
              ],
            );
          },
        );
      },
    );

    if (coins == null) return;
    setState(() {
      _customModel = _CoinAddModel(balance: coins, tmtBalance: coins / 10);
      _selected = _customModel!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.bal_al),
        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.28),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              FadeRoute(
                page: BlocProvider.value(
                  value: _coinHistoryBloc,
                  child: const CoinHistoryScreen(),
                ),
              ),
            ),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _openTopUpSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              loc.dowam_et,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),

      body: BlocListener<CoinHistoryBloc, CoinHistoryState>(
        bloc: _coinHistoryBloc,
        listener: (context, state) {
          final loc = S.of(context);
          if (state is CoinTopupSubmitSuccess) {
            MyHelpers.showMessage(
              loc.coin_topup_success,
              AppColors.successGreen,
              context,
            );
            _coinHistoryBloc.add(const LoadCoinTopupsEvent());
          }
          if (state is CoinTopupSubmitError) {
            MyHelpers.showMessage(state.message, AppColors.errorRed, context);
          }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.bal_galyndy,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      BlocBuilder<CoinBloc, CoinState>(
                        builder: (context, cointState) {
                          final balance = cointState is CoinLoaded
                              ? cointState.coin.balance
                              : 0.0;
                          return Row(
                            children: [
                              Image.asset(
                                'assets/images/coin_image.png',
                                height: 35,
                                width: 35,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                balance.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsetsGeometry.all(15),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.balans_doldurmak,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsGeometry.all(1),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          ..._balances.map(
                            (item) => _AddBalanceItem(
                              model: item,
                              isSelected: _selected == item,
                              onTap: () => setState(() => _selected = item),
                            ),
                          ),
                          _CustomAddBalanceItem(
                            model: _customModel,
                            isSelected:
                                _customModel != null &&
                                _selected == _customModel,
                            onTap: _openCustomAmountDialog,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),

        //   NestedScrollView(
        //     headerSliverBuilder: (context, innerBoxIsScrolled) {
        //       return [
        //         SliverToBoxAdapter(
        //           child: BlocBuilder<CoinBloc, CoinState>(
        //             builder: (context, coinState) {
        //               return CoinBalanceHeader(
        //                 balance: coinState is CoinLoaded
        //                     ? coinState.coin.balance
        //                     : null,
        //                 isLoading:
        //                     coinState is CoinLoading || coinState is CoinInitial,
        //                 onTopUp: _openTopUpSheet,
        //               );
        //             },
        //           ),
        //         ),

        //         SliverPersistentHeader(
        //           pinned: true,
        //           delegate: _TabBarDelegate(
        //             TabBar(
        //               controller: _tabController,
        //               labelColor: AppColors.primaryGreen,
        //               unselectedLabelColor: Colors.grey,
        //               indicatorColor: AppColors.primaryGreen,
        //               tabs: [
        //                 Tab(text: loc.coin_history_tab),
        //                 Tab(text: loc.coin_topup_tab),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ];
        //     },
        //     body: TabBarView(
        //       controller: _tabController,
        //       children: [
        //         BlocBuilder<CoinHistoryBloc, CoinHistoryState>(
        //           bloc: _coinHistoryBloc,
        //           builder: (context, state) {
        //             final isInitialLoading =
        //                 state is CoinHistoryLoading && _history.isEmpty;
        //             final isLoadingMore =
        //                 state is CoinHistoryLoaded && state.isLoadingMore;

        //             context.read<CoinBloc>().add(LoadCoinBalanceEvent());

        //             if (isInitialLoading) {
        //               return ListView.builder(
        //                 padding: const EdgeInsets.symmetric(vertical: 8),
        //                 itemCount: 6,
        //                 itemBuilder: (_, _) => const CoinTileShimmer(),
        //               );
        //             }

        //             if (_history.isEmpty) {
        //               return Center(
        //                 child: MyEmptyWidget(emptyText: loc.coin_history_empty),
        //               );
        //             }

        //             return ListView.builder(
        //               controller: _historyScrollController,
        //               padding: const EdgeInsets.symmetric(vertical: 8),
        //               itemCount: _history.length + (isLoadingMore ? 1 : 0),
        //               itemBuilder: (context, index) {
        //                 if (index < _history.length) {
        //                   return CoinHistoryTile(item: _history[index]);
        //                 }
        //                 return const CoinTileShimmer();
        //               },
        //             );
        //           },
        //         ),
        //         BlocBuilder<CoinHistoryBloc, CoinHistoryState>(
        //           bloc: _coinHistoryBloc,
        //           builder: (context, state) {
        //             final isInitialLoading =
        //                 state is CoinTopupsLoading && _topups.isEmpty;
        //             final isLoadingMore =
        //                 state is CoinTopupsLoaded && state.isLoadingMore;

        //             if (isInitialLoading) {
        //               return ListView.builder(
        //                 padding: const EdgeInsets.symmetric(vertical: 8),
        //                 itemCount: 6,
        //                 itemBuilder: (_, _) => const CoinTileShimmer(),
        //               );
        //             }

        //             if (_topups.isEmpty) {
        //               return Center(
        //                 child: MyEmptyWidget(emptyText: loc.coin_topup_empty),
        //               );
        //             }

        //             return ListView.builder(
        //               controller: _topupScrollController,
        //               padding: const EdgeInsets.symmetric(vertical: 8),
        //               itemCount: _topups.length + (isLoadingMore ? 1 : 0),
        //               itemBuilder: (context, index) {
        //                 if (index < _topups.length) {
        //                   return CoinTopupTile(item: _topups[index]);
        //                 }
        //                 return const CoinTileShimmer();
        //               },
        //             );
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        //
      ),
    );
  }
}

class _CoinAddModel {
  final double balance;
  final double tmtBalance;

  _CoinAddModel({required this.balance, required this.tmtBalance});
}

class _AddBalanceItem extends StatelessWidget {
  final _CoinAddModel model;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddBalanceItem({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  String _format(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 109,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/coin_image.png',
                  height: 32,
                  width: 32,
                ),
                const SizedBox(width: 2),
                Text(
                  _format(model.balance),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: isSelected ? AppColors.primaryGreen : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${_format(model.tmtBalance)} TMT',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The grid's last tile — lets the user type their own coin amount instead
/// of picking a preset. Shows a "+" prompt until a value has been entered,
/// then displays it just like the preset tiles (still tappable, to edit it).
class _CustomAddBalanceItem extends StatelessWidget {
  final _CoinAddModel? model;
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomAddBalanceItem({
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  String _format(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final model = this.model;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 109,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: model == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.grey.shade500, size: 32),
                  const SizedBox(height: 2),
                  Text(
                    'Başga',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/coin_image.png',
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _format(model.balance),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_format(model.tmtBalance)} TMT',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
