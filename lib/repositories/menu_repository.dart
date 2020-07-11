import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/menu.dart';

import 'package:huynhcodaidao/services/menu_service.dart';

class MenuRepository {
  final Box _appData = Hive.box('appData');
  final MenuService _menuService = MenuService(Dio());

  Future<Menu> get({
    @required String slug,
  }) async {
    UserToken userToken = _appData.get('userToken');
    Menu menu = await _menuService.get(
      token: 'Bearer ' + userToken.accessToken,
      slug: slug,
    );

    return menu;
  }
}
