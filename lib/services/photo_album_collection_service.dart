import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:huynhcodaidao/models/photo_album_collection.dart';

part 'photo_album_collection_service.g.dart';

@RestApi(baseUrl: 'https://nova.huynhcodaidao.com/')
abstract class PhotoAlbumCollectionService {
  factory PhotoAlbumCollectionService(Dio dio, {String baseUrl}) =
      _PhotoAlbumCollectionService;

  @GET('{path}')
  Future<PhotoAlbumCollection> get({
    @Path('path') String path,
    @Header('Authorization') String token,
    @Query("page") int page,
  });
}
