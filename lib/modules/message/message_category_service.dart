import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:huynhcodaidao/modules/message/message_category.dart';

part 'message_category_service.g.dart';

@RestApi(baseUrl: 'https://nova.huynhcodaidao.com/')
abstract class MessageCategoryService {
  factory MessageCategoryService(Dio dio, {String baseUrl}) = _MessageCategoryService;

  @GET('{path}')
  Future<MessageCategory> get({
    @Path('path') String path,
    @Header('Authorization') String token,
    @Query("page") int page,
  });
}
