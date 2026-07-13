import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/pages/home_page.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/bottom_nav_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/my_mbium_page.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:mbium_mobile_client/feature/chats/presentation/pages/chats_page.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/page/cart_page.dart';

import '../../reels/presentation/reels_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pages = <Widget>[
    const HomePage(),
    const ReelsPage(),
    const ChatsPage(),
    const CartPage(),
    const MyMbiumPage(),
  ];

  DateTime? _lastBackPressTime;

  void _onBackPressed() {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нажмите ещё раз для выхода'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final currentIndex = state.navigationIndex;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _onBackPressed();
          },
          child: Scaffold(
            body: _pages[currentIndex],
            bottomNavigationBar: BottomNavWidget(currentIndex: currentIndex),
          ),
        );
      },
    );
  }
}
