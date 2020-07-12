import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:bloc/bloc.dart';

import 'package:huynhcodaidao/models/user_token.dart';

import 'package:huynhcodaidao/blocs/authentication_event.dart';
import 'package:huynhcodaidao/blocs/authentication_state.dart';

import 'package:huynhcodaidao/repositories/user_repository.dart';

final GetIt getIt = GetIt.instance;

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository = getIt.get<UserRepository>();

  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield AuthenticationInProgress();
      final UserToken userToken = await _userRepository.getToken();
      await Future.delayed(Duration(seconds: 3));

      if (userToken != null) {
        yield AuthenticationSuccess();
      } else {
        yield AuthenticationFailure();
      }
    }

    if (event is AuthenticationLoggedIn) {
      yield AuthenticationInProgress();
      await _userRepository.putToken(event.userToken);
      yield AuthenticationSuccess();
    }

    if (event is AuthenticationLoggedOut) {
      yield AuthenticationInProgress();
      await _userRepository.deleteToken();
      yield AuthenticationFailure();
    }
  }
}
