import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/home_screen.dart';
import 'package:mbium_mobile_client/feature/splash/presentation/splash_screen.dart';

import 'FadeRouter.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeRoute(page: const SplashScreen());
    case '/home':
      return FadeRoute(page: const HomeScreen());

    default:
      return FadeRoute(
        page: Scaffold(body: Center(child: Text('404 Screen not Found'))),
      );
  }
}
