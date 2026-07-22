import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../../generated/l10n.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final localilzation = S.of(context);
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.navigationIndex,
          onTap: (index) {
            context.read<MainBloc>().add(SetNavigationPageEvent(index: index));
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/logo_kici.png'),
              label: ' ',
            ),
            BottomNavigationBarItem(
              icon: SvgIcon(
                iconName: 'assets/icons/reels.svg',
                color: state.navigationIndex == 1
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.secondary,
              ),
              label: localilzation.reels,
            ),

            BottomNavigationBarItem(
              icon: SvgIcon(
                iconName: 'assets/icons/chat_icon.svg',
                color: state.navigationIndex == 2
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.secondary,
              ),
              label: localilzation.chats,
            ),

            BottomNavigationBarItem(
              icon: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  final count = cartState is CartLoaded
                      ? cartState.itemCount
                      : 0;
                  return Badge(
                    isLabelVisible: count > 0,
                    label: Text(
                      '$count',
                      style: const TextStyle(fontSize: 6),
                    ),
                    child: SvgIcon(
                      iconName: 'assets/icons/cart_icon.svg',
                      color: state.navigationIndex == 3
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  );
                },
              ),
              label: localilzation.card,
            ),

            BottomNavigationBarItem(
              icon: SvgIcon(
                iconName: 'assets/icons/profile_icon.svg',
                color: state.navigationIndex == 4
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.secondary,
              ),
              label: localilzation.my_mbium,
            ),
          ],
        );
      },
    );
  }
}
