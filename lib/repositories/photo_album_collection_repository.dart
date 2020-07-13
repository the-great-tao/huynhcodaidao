import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import 'package:huynhcodaidao/models/user_token.dart';
import 'package:huynhcodaidao/models/photo_album_collection.dart';

import 'package:huynhcodaidao/services/photo_album_collection_service.dart';

final GetIt getIt = GetIt.instance;

class PhotoAlbumCollectionRepository {
  final Box _appData = Hive.box('appData');
  final PhotoAlbumCollectionService _photoAlbumCollectionService =
      getIt.get<PhotoAlbumCollectionService>();

  Future<PhotoAlbumCollection> get({
    @required String path,
    int page = 1,
    bool fullUrl = false,
  }) async {
    PhotoAlbumCollectionService photoAlbumCollectionService =
        _photoAlbumCollectionService;
    UserToken userToken = _appData.get('userToken');

    if (fullUrl) {
      photoAlbumCollectionService =
          PhotoAlbumCollectionService(Dio(), baseUrl: path);
      path = '/';
    }

    return photoAlbumCollectionService.get(
      path: path,
      token: 'Bearer ' + userToken.accessToken,
      page: page,
    );
  }
}
