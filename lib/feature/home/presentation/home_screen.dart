import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/pages/home_page.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/bottom_nav_widget.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/my_mbium_page.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:mbium_mobile_client/feature/chats/presentation/pages/chats_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pages = <Widget>[
    const HomePage(),
    Center(child: Text('REELS')),
    const ChatsPage(),  
    Center(child: Text('CARD')),
    const MyMbiumPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final currentIndex = state.navigationIndex;
        return Scaffold(
          body: _pages[currentIndex],
          bottomNavigationBar: BottomNavWidget(currentIndex: currentIndex),
        );
      },
    );
  }
}
