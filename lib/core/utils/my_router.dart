import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/pages/account_verified_screen.dart';
import 'package:mbium_mobile_client/feature/balance/presentation/pages/balance_screen.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_model.dart';
import 'package:mbium_mobile_client/feature/brands/presentation/brand_detail_screen.dart';
import 'package:mbium_mobile_client/feature/brands/presentation/brands_screen.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/sargyt_et_screen.dart';
import 'package:mbium_mobile_client/feature/category/presentation/category_screen.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_model.dart';
import 'package:mbium_mobile_client/feature/collections/presentation/collection_detail_screen.dart';
import 'package:mbium_mobile_client/feature/cupons/presentation/my_cupons_screen.dart';
import 'package:mbium_mobile_client/feature/home/presentation/home_screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/hasabym/hasabym_screen.dart';
import 'package:mbium_mobile_client/feature/oz_bahany/presentation/oz_bahan_rfq_screen.dart';
import 'package:mbium_mobile_client/feature/person/presentation/create_new_user_screen.dart';
import 'package:mbium_mobile_client/feature/person/presentation/login_by_phone.dart';
import 'package:mbium_mobile_client/feature/person/presentation/login_in_screen.dart';
import 'package:mbium_mobile_client/feature/person/presentation/otp_verified_screen.dart';
import 'package:mbium_mobile_client/feature/person/presentation/person_screen.dart';
import 'package:mbium_mobile_client/feature/person/presentation/reg_shop_screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/abuna_Screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/addresses/addresses_screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/ai_podpiska_screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/all_functions_screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/support_screen.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/ulanys_duzgunleri_screen.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/presentation/mugt_dostawka_screen.dart';
import 'package:mbium_mobile_client/feature/products/presentation/recently_review_screen.dart';
import 'package:mbium_mobile_client/feature/comments/presentation/product_review_screen.dart';
import 'package:mbium_mobile_client/feature/search/model/search_model.dart';
import 'package:mbium_mobile_client/feature/search/presentation/my_search_screen.dart';
import 'package:mbium_mobile_client/feature/settings/presentation/settings_screen.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/product_detail_screen.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/shop_detail_screen.dart';
import 'package:mbium_mobile_client/feature/splash/presentation/splash_screen.dart';
import 'package:mbium_mobile_client/feature/tolegler/presentation/tolegler_Screen.dart';
import 'package:mbium_mobile_client/feature/top_products/presentation/pages/top_products_page.dart';

import '../../feature/favorite/presentation/favorite_screen.dart';
import '../../feature/home/presentation/oz_bahany_sayla_screen.dart';
import '../../feature/message/presentation/chats_screen.dart';
import '../../feature/orders/presentation/orders_screen.dart';
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
    case '/favorite':
      return FadeRoute(page: const FavoriteScreen());
    case '/shopDetail':
      final shopModel = settings.arguments as ShopModel;
      return FadeRoute(page: ShopDetailScreen(shopModel: shopModel));
    case '/reg_shop':
      return FadeRoute(page: const RegShopScreen());
    case '/aiPodpiska':
      return FadeRoute(page: const AiPodpiskaScreen());
    case '/addresses':
      return FadeRoute(page: const AddressesScreen());
    case '/allFunctions':
      return FadeRoute(page: const AllFunctionsScreen());
    case '/orders':
      return FadeRoute(page: const OrdersScreen());
    case '/review':
      return FadeRoute(page: const RecentlyReviewScreen());
    case '/cupons':
      return FadeRoute(page: const MyCuponsScreen());
    case '/support':
      return FadeRoute(page: const SupportScreen());
    case '/duzgunler':
      return FadeRoute(page: const UlanysDuzgunleriScreen());
    case '/tolegler':
      return FadeRoute(page: const ToleglerScreen());
    case '/abuna':
      return FadeRoute(page: const AbunaScreen());
    case '/sargytEt':
      return FadeRoute(page: const SargytEtScreen());
    case '/chats':
      return FadeRoute(page: const ChatsScreen());
    case '/ozBahanySayla':
      return FadeRoute(page: const OzBahanySaylaScreen());
    case '/rfqScreen':
      return FadeRoute(page: const OzBahanRfqScreen());
    case '/register':
      return FadeRoute(page: const CreateNewUserScreen());
    case '/profil':
      return FadeRoute(page: const PersonScreen());
    case '/balance':
      return FadeRoute(page: const BalanceScreen());
    case '/verifyAccount':
      return FadeRoute(page: const AccountVerifiedScreen());

    case '/otpVerify':
      final session = settings.arguments as String;
      return FadeRoute(page: OtpVerifiedScreen(sessionId: session));
    case '/hasabym':
      return FadeRoute(page: const HasabymScreen());
    case '/productReview':
      final id = settings.arguments as int;
      return FadeRoute(page: ProductReviewScreen(productId: id));
    case '/loginIn':
      return FadeRoute(page: const LoginInScreen());
    case '/searchScreen':
      final model = settings.arguments as SearchModel;
      return FadeRoute(
        page: BlocProvider(
          create: (context) =>
              ProductBloc(repository: context.read<ProductRepository>()),
          child: MySearchScreen(searchModel: model),
        ),
      );
    case '/mugtDostawka':
      return FadeRoute(
        page: BlocProvider(
          create: (context) =>
              ProductBloc(repository: context.read<ProductRepository>()),
          child: const MugtDostawkaScreen(),
        ),
      );
    case '/phoneAuth':
      return FadeRoute(page: const LoginByPhoneScreen());
    case '/brands':
      return FadeRoute(page: const BrandsScreen());
    case '/brandDetail':
      final brandModel = settings.arguments as BrandModel;
      return FadeRoute(page: BrandDetailScreen(brandModel: brandModel));
    case '/collectionDetail':
      final collection = settings.arguments as CollectionModel;
      return FadeRoute(page: CollectionDetailScreen(collection: collection));

    default:
      return FadeRoute(
        page: Scaffold(body: Center(child: Text('404 Screen not Found'))),
      );
  }
}
