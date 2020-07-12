import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:huynhcodaidao/models/menu.dart';

part 'menu_service.g.dart';

@RestApi(baseUrl: 'https://nova.huynhcodaidao.com/')
abstract class MenuService {
  factory MenuService(Dio dio, {String baseUrl}) = _MenuService;

  @GET('/app/menu/{slug}')
  Future<Menu> get({
    @Path('slug') String slug,
    @Header('Authorization') String token,
    @Query("page") int page,
  });
}
