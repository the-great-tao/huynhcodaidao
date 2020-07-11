import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:huynhcodaidao/blocs/authentication_event.dart';
import 'package:huynhcodaidao/blocs/authentication_bloc.dart';
import 'package:huynhcodaidao/blocs/login_screen_event.dart';
import 'package:huynhcodaidao/blocs/login_screen_state.dart';

import 'package:huynhcodaidao/repositories/user_repository.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  // ignore: close_sinks
  final AuthenticationBloc authenticationBloc;
  final UserRepository userRepository;

  LoginScreenBloc({
    @required this.authenticationBloc,
    @required this.userRepository,
  })  : assert(authenticationBloc != null),
        assert(userRepository != null),
        super(LoginScreenInitial());

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    if (event is LoginScreenObscureOptionTapped) {
      yield LoginScreenObscureOptionChanged(
        obscureOption: !event.obscureOption,
      );
    }

    if (event is LoginScreenLoginButtonPressed) {
      yield LoginScreenInProgress();

      try {
        final userToken = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        authenticationBloc.add(AuthenticationLoggedIn(userToken: userToken));
        yield LoginScreenSuccess();
      } catch (error) {
        yield LoginScreenFailure(error: error);
      }
    }
  }
}
