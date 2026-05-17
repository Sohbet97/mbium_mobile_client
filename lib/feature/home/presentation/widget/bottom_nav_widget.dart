import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final localilzation = S.of(context);
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/logo_kici.png'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_call),
          label: localilzation.reels,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.video_call),
          label: localilzation.chats,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.video_call),
          label: localilzation.card,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.video_call),
          label: localilzation.my_mbium,
        ),
      ],
    );
  }
}
