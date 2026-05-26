import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/repository/category_repository.dart';
import 'package:mbium_mobile_client/feature/collections/bloc/collection_bloc.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/home/bloc/ai_bloc.dart';
import 'package:mbium_mobile_client/feature/home/data/ai_repository.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/cart_page/data/cart_repository.dart';
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';
import 'package:mbium_mobile_client/feature/person/data/person_repository.dart';

import 'package:permission_handler/permission_handler.dart';

import 'core/constants/app_locales.dart';
import 'core/firebase/firebase_services.dart';
import 'core/firebase/notification_setup.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/localization/app_localization_delegates.dart';
import 'core/network/api_client.dart';
import 'core/storage/app_preferences.dart';
import 'core/themes/theme.dart';
import 'core/utils/my_router.dart';
import 'feature/splash/bloc/main_bloc.dart';
import 'feature/splash/data/main_repository.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
ThemeMode themeMode = ThemeMode.light;
bool isDarkTheme = false;
String systemLanguage = "tm";
final String myMediaUrl = 'http://172.20.19.99:9000/';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appPreferences = await AppPreferences.create();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: false);
  await Permission.notification.request();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await requestPermission();

  runApp(MyApp(appPreferences: appPreferences));
}

void initFcmListeners(BuildContext context) {
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    // context.read<PersonBloc>().add(UpdateFcmToken());
  });
}

void initForegroundNotifications(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_notification',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
        payload: data['order_id'],
      );
    }
  });
}

class MyApp extends StatefulWidget {
  final AppPreferences appPreferences;
  const MyApp({super.key, required this.appPreferences});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    initFcmListeners(context);
    initForegroundNotifications(context);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      openOrderFromNotification(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        openOrderFromNotification(message.data);
      }
    });
  }

  void openOrderFromNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'];

    if (orderId != null) {
      navigatorKey.currentState?.pushNamed(
        '/order',
        arguments: int.parse(orderId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ApiClient apiClient = ApiClient();

    return MultiRepositoryProvider(
      providers: [
        // main
        RepositoryProvider(
          create: (context) => MainRepository(dio: apiClient.dio),
        ),

        // person
        RepositoryProvider(
          create: (context) => PersonRepository(
            dio: apiClient.dio,
            preferences: widget.appPreferences,
          ),
        ),

        // ai repository
        RepositoryProvider(
          create: (context) => AiRepository(
            dio: apiClient.dio,
            appPreferences: widget.appPreferences,
          ),
        ),

        // category
        RepositoryProvider(
          create: (context) => CategoryRepository(dio: apiClient.dio),
        ),

        // products
        RepositoryProvider(
          create: (context) => ProductRepository(dio: apiClient.dio),
        ),

        // cart
        RepositoryProvider(
          create: (context) => CartRepository(
            dio: apiClient.dio,
            appPreferences: widget.appPreferences,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          //main
          BlocProvider(
            create: (context) => MainBloc(
              dio: apiClient.dio,
              appPreferences: widget.appPreferences,
            )..add(const MainInitial()),
          ),

          // person
          BlocProvider(
            create: (context) =>
                PersonBloc(repository: context.read<PersonRepository>()),
          ),

          // ai bloc
          BlocProvider(
            create: (context) =>
                AiBloc(repository: context.read<AiRepository>()),
          ),

          // category
          BlocProvider(
            create: (context) =>
                CategoryBloc(repository: context.read<CategoryRepository>())
                  ..add(LoadCategoriesEvent(isRefresh: true)),
          ),

          //product
          BlocProvider(
            create: (context) =>
                ProductBloc(repository: context.read<ProductRepository>()),
          ),

          // collections
          BlocProvider(
            create: (context) =>
                CollectionBloc(dio: apiClient.dio)
                  ..add(LoadAllCollectionEvent()),
          ),

          // cart
          BlocProvider(
            create: (context) => CartBloc(
              repository: context.read<CartRepository>(),
            )..add(const LoadCartEvent()),
          ),
        ],
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return MaterialApp(
              themeMode: state.themeMode,
              darkTheme: darkTheme,
              theme: lightTheme,
              locale: Locale(state.languageCode),
              supportedLocales: appSupportedLocales,
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              navigatorObservers: [routeObserver],
              initialRoute: '/',
              onGenerateRoute: onGenerateRoute,
              localizationsDelegates: appLocalizationDelegates,
            );
          },
        ),
      ),
    );
  }
}
