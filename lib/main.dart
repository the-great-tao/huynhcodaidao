import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' as Services;
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:huynhcodaidao/models/user_token.dart';

import 'package:huynhcodaidao/blocs/global_bloc_observer.dart';
import 'package:huynhcodaidao/blocs/authentication_event.dart';
import 'package:huynhcodaidao/blocs/authentication_state.dart';
import 'package:huynhcodaidao/blocs/authentication_bloc.dart';
import 'package:huynhcodaidao/blocs/login_screen_bloc.dart';

import 'package:huynhcodaidao/repositories/user_repository.dart';
import 'package:huynhcodaidao/repositories/menu_repository.dart';

import 'package:huynhcodaidao/services/user_service.dart';
import 'package:huynhcodaidao/services/menu_service.dart';

import 'package:huynhcodaidao/screens/splash_screen.dart';
import 'package:huynhcodaidao/screens/login_screen.dart';
import 'package:huynhcodaidao/screens/home_screen.dart';
import 'package:huynhcodaidao/screens/menu_screen.dart';
import 'package:huynhcodaidao/screens/webview_screen.dart';

final GetIt getIt = GetIt.instance;

Future setupGetIt() async {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<UserService>(
    () => UserService(Dio()),
  );
  getIt.registerLazySingleton<MenuService>(
    () => MenuService(Dio()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(),
  );
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepository(),
  );
  getIt.registerLazySingleton<Router>(
    () => Router(),
  );
}

Future setupAppData() async {
  final FlutterSecureStorage secureStorage = getIt.get<FlutterSecureStorage>();
  final String _appDataKey = await secureStorage.read(key: 'appDataKey');
  List<int> appDataKey;

  if (_appDataKey != null) {
    appDataKey = List<int>.from(jsonDecode(_appDataKey));
  } else {
    appDataKey = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'appDataKey',
      value: jsonEncode(appDataKey),
    );
  }

  await Hive.initFlutter('hive');

  Hive.registerAdapter(UserTokenAdapter());

  await Hive.openBox(
    'appData',
    encryptionCipher: HiveAesCipher(appDataKey),
  );
}

Future setupRouter() async {
  final Router router = getIt.get<Router>();

  router.define(
    '/home/',
    transitionType: TransitionType.fadeIn,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return HomeScreen();
    }),
  );

  router.define(
    '/menu/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String actionUrl = params['actionUrl'][0];
      String actionTitle = params['actionTitle'][0];

      actionUrl = utf8.decode(base64Url.decode(actionUrl));
      actionTitle = utf8.decode(base64Url.decode(actionTitle));

      return MenuScreen(
        actionUrl: actionUrl,
        actionTitle: actionTitle,
      );
    }),
  );

  router.define(
    '/webview/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String actionUrl = params['actionUrl'][0];
      String actionTitle = params['actionTitle'][0];

      actionUrl = utf8.decode(base64Url.decode(actionUrl));
      actionTitle = utf8.decode(base64Url.decode(actionTitle));

      return WebviewScreen(
        actionUrl: actionUrl,
        actionTitle: actionTitle,
      );
    }),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Services.SystemChrome.setPreferredOrientations([
    Services.DeviceOrientation.portraitUp,
    Services.DeviceOrientation.portraitDown,
  ]);

  await setupGetIt();
  await setupAppData();
  await setupRouter();

  Bloc.observer = GlobalBlocObserver();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (BuildContext context) => BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) {
          return AuthenticationBloc()..add(AuthenticationStarted());
        },
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: getIt.get<Router>().generator,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.of(context).locale,
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          Widget home = SplashScreen();

          if (state is AuthenticationSuccess) {
            home = HomeScreen();
          }

          if (state is AuthenticationFailure) {
            home = BlocProvider(
              create: (context) {
                // ignore: close_sinks
                final AuthenticationBloc authenticationBloc =
                    BlocProvider.of<AuthenticationBloc>(context);

                return LoginScreenBloc(
                  authenticationBloc: authenticationBloc,
                );
              },
              child: LoginScreen(),
            );
          }

          return home;
        },
      ),
    );
  }
}
