import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' as Services;
import 'package:flutter/material.dart' hide Router;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:huynhcodaidao/models/user_token.dart';

import 'package:huynhcodaidao/blocs/global_bloc_observer.dart';
import 'package:huynhcodaidao/blocs/authentication_event.dart';
import 'package:huynhcodaidao/blocs/authentication_state.dart';
import 'package:huynhcodaidao/blocs/authentication_bloc.dart';
import 'package:huynhcodaidao/blocs/login_screen_bloc.dart';
import 'package:huynhcodaidao/blocs/audio_controller_event.dart';
import 'package:huynhcodaidao/blocs/audio_controller_bloc.dart';

import 'package:huynhcodaidao/repositories/user_repository.dart';
import 'package:huynhcodaidao/repositories/menu_repository.dart';
import 'package:huynhcodaidao/repositories/photo_album_collection_repository.dart';
import 'package:huynhcodaidao/repositories/audio_album_collection_repository.dart';
import 'package:huynhcodaidao/repositories/photo_album_repository.dart';
import 'package:huynhcodaidao/repositories/audio_album_repository.dart';

import 'package:huynhcodaidao/services/user_service.dart';
import 'package:huynhcodaidao/services/menu_service.dart';
import 'package:huynhcodaidao/services/photo_album_collection_service.dart';
import 'package:huynhcodaidao/services/audio_album_collection_service.dart';
import 'package:huynhcodaidao/services/photo_album_service.dart';
import 'package:huynhcodaidao/services/audio_album_service.dart';

import 'package:huynhcodaidao/screens/splash_screen.dart';
import 'package:huynhcodaidao/screens/login_screen.dart';
import 'package:huynhcodaidao/screens/home_screen.dart';
import 'package:huynhcodaidao/screens/menu_screen.dart';
import 'package:huynhcodaidao/screens/webview_screen.dart';
import 'package:huynhcodaidao/screens/photo_album_collection_screen.dart';
import 'package:huynhcodaidao/screens/audio_album_collection_screen.dart';
import 'package:huynhcodaidao/screens/photo_album_screen.dart';
import 'package:huynhcodaidao/screens/audio_album_screen.dart';

import 'package:huynhcodaidao/modules/message/message_category_repository.dart';
import 'package:huynhcodaidao/modules/message/message_category_service.dart';
import 'package:huynhcodaidao/modules/message/message_category_screen.dart';

import 'package:huynhcodaidao/screens/pdf_view_screen.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

final GetIt getIt = GetIt.instance;

Future setupGetIt() async {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<Router>(
    () => Router(),
  );
  getIt.registerLazySingleton<AssetsAudioPlayer>(
    () => AssetsAudioPlayer(),
  );

  getIt.registerLazySingleton<UserService>(
    () => UserService(Dio()),
  );
  getIt.registerLazySingleton<MenuService>(
    () => MenuService(Dio()),
  );
  getIt.registerLazySingleton<PhotoAlbumCollectionService>(
    () => PhotoAlbumCollectionService(Dio()),
  );
  getIt.registerLazySingleton<AudioAlbumCollectionService>(
    () => AudioAlbumCollectionService(Dio()),
  );
  getIt.registerLazySingleton<PhotoAlbumService>(
    () => PhotoAlbumService(Dio()),
  );
  getIt.registerLazySingleton<AudioAlbumService>(
    () => AudioAlbumService(Dio()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(),
  );
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepository(),
  );
  getIt.registerLazySingleton<PhotoAlbumCollectionRepository>(
    () => PhotoAlbumCollectionRepository(),
  );
  getIt.registerLazySingleton<AudioAlbumCollectionRepository>(
    () => AudioAlbumCollectionRepository(),
  );
  getIt.registerLazySingleton<PhotoAlbumRepository>(
    () => PhotoAlbumRepository(),
  );
  getIt.registerLazySingleton<AudioAlbumRepository>(
    () => AudioAlbumRepository(),
  );

  getIt.registerLazySingleton<MessageCategoryService>(
    () => MessageCategoryService(Dio()),
  );
  getIt.registerLazySingleton<MessageCategoryRepository>(
    () => MessageCategoryRepository(),
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

  router.define(
    '/photo_album_list/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String actionUrl = params['actionUrl'][0];
      String actionTitle = params['actionTitle'][0];

      actionUrl = utf8.decode(base64Url.decode(actionUrl));
      actionTitle = utf8.decode(base64Url.decode(actionTitle));

      return PhotoAlbumCollectionScreen(
        actionUrl: actionUrl,
        actionTitle: actionTitle,
      );
    }),
  );

  router.define(
    '/audio_album_list/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String actionUrl = params['actionUrl'][0];
      String actionTitle = params['actionTitle'][0];

      actionUrl = utf8.decode(base64Url.decode(actionUrl));
      actionTitle = utf8.decode(base64Url.decode(actionTitle));

      return AudioAlbumCollectionScreen(
        actionUrl: actionUrl,
        actionTitle: actionTitle,
      );
    }),
  );

  router.define(
    '/photo_album/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String actionUrl = params['actionUrl'][0];
      String actionTitle = params['actionTitle'][0];

      actionUrl = utf8.decode(base64Url.decode(actionUrl));
      actionTitle = utf8.decode(base64Url.decode(actionTitle));

      return PhotoAlbumScreen(
        actionUrl: actionUrl,
        actionTitle: actionTitle,
      );
    }),
  );

  router.define(
    '/audio_album/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String actionUrl = params['actionUrl'][0];
      String actionTitle = params['actionTitle'][0];

      actionUrl = utf8.decode(base64Url.decode(actionUrl));
      actionTitle = utf8.decode(base64Url.decode(actionTitle));

      return AudioAlbumScreen(
        actionUrl: actionUrl,
        actionTitle: actionTitle,
      );
    }),
  );

  router.define(
    '/message_list/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String actionUrl = params['actionUrl'][0];
      String actionTitle = params['actionTitle'][0];

      actionUrl = utf8.decode(base64Url.decode(actionUrl));
      actionTitle = utf8.decode(base64Url.decode(actionTitle));

      return MessageCategoryScreen(
        actionUrl: actionUrl,
        actionTitle: actionTitle,
      );
    }),
  );

  router.define(
    '/pdf_view/',
    transitionType: TransitionType.inFromRight,
    handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          String actionUrl = params['actionUrl'][0];
          String actionTitle = params['actionTitle'][0];

          actionUrl = utf8.decode(base64Url.decode(actionUrl));
          actionTitle = utf8.decode(base64Url.decode(actionTitle));

          return PdfViewScreen(
            actionUrl: actionUrl,
            actionTitle: actionTitle,
          );
        }),
  );
}

Future setupOneSignal() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.init(
    'f48e46de-3348-4775-9c38-da36af3b4199',
    iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false,
    },
  );
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);

  await OneSignal.shared.setExternalUserId('123456789');
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
  await setupOneSignal();

  Bloc.observer = GlobalBlocObserver();

  runApp(
    DevicePreview(
      enabled: false, // !kReleaseMode,
      builder: (BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) {
              return AuthenticationBloc()..add(AuthenticationStarted());
            },
          ),
          BlocProvider<AudioControllerBloc>(
            create: (BuildContext context) {
              return AudioControllerBloc()..add(AudioControllerHide());
            },
          ),
        ],
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
      locale: DevicePreview.locale(context),
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
