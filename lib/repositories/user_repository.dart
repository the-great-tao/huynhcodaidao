import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

import 'package:huynhcodaidao/models/user_token.dart';

import 'package:huynhcodaidao/services/user_service.dart';

class UserRepository {
  final Box _appData = Hive.box('appData');
  final UserService _userService = UserService(Dio());

  Future<UserToken> authenticate({
    @required String username,
    @required String password,
  }) async {
    UserToken userToken = await _userService.authenticate(
      username: username,
      password: password,
    );

    return userToken;
  }

  Future<void> putToken(UserToken userToken) async {
    await _appData.put('userToken', userToken);
  }

  Future<UserToken> getToken() async {
    return _appData.get('userToken');
  }

  Future<void> deleteToken() async {
    await _appData.delete('userToken');
  }
}
