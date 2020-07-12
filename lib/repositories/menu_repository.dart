import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/menu.dart';

import 'package:huynhcodaidao/services/menu_service.dart';

final GetIt getIt = GetIt.instance;

class MenuRepository {
  final Box _appData = Hive.box('appData');
  final MenuService _menuService = getIt.get<MenuService>();

  Future<Menu> get({
    @required String slug,
    int page = 1,
  }) async {
    UserToken userToken = _appData.get('userToken');

    return _menuService.get(
      slug: slug,
      token: 'Bearer ' + userToken.accessToken,
      page: page,
    );
  }
}
