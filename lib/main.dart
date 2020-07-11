import 'dart:convert';

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

import 'package:huynhcodaidao/blocs/authentication_event.dart';
import 'package:huynhcodaidao/blocs/authentication_state.dart';
import 'package:huynhcodaidao/blocs/authentication_bloc.dart';
import 'package:huynhcodaidao/blocs/login_screen_bloc.dart';
import 'package:huynhcodaidao/blocs/global_bloc_observer.dart';

import 'package:huynhcodaidao/repositories/user_repository.dart';

import 'package:huynhcodaidao/screens/splash_screen.dart';
import 'package:huynhcodaidao/screens/login_screen.dart';
import 'package:huynhcodaidao/screens/home_screen.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
final UserRepository userRepository = UserRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Services.SystemChrome.setPreferredOrientations([
    Services.DeviceOrientation.portraitUp,
    Services.DeviceOrientation.portraitDown,
  ]);

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

  Bloc.observer = GlobalBlocObserver();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => BlocProvider<AuthenticationBloc>(
        create: (context) {
          return AuthenticationBloc(userRepository: userRepository)
            ..add(AuthenticationStarted());
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
                  userRepository: userRepository,
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
