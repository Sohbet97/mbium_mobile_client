import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/category/presentation/category_screen.dart';
import 'package:mbium_mobile_client/feature/home/presentation/home_screen.dart';
import 'package:mbium_mobile_client/feature/settings/presentation/settings_screen.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/product_detail_screen.dart';
import 'package:mbium_mobile_client/feature/splash/presentation/splash_screen.dart';
import 'package:mbium_mobile_client/feature/top_products/presentation/pages/top_products_page.dart';

import 'FadeRouter.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeRoute(page: const SplashScreen());
    case '/home':
      return FadeRoute(page: const HomeScreen());
    case '/categories':
      return FadeRoute(page: const CategoriesScreen());
    case '/settings':
      return FadeRoute(page: const SettingsScreen());
    case '/top-products':
      return FadeRoute(page: const TopProductsPage());
    case '/productDetail':
      final product = settings.arguments as ProductModel;
      return FadeRoute(page: ProductDetailScreen(product: product));
    default:
      return FadeRoute(
        page: Scaffold(body: Center(child: Text('404 Screen not Found'))),
      );
  }
}