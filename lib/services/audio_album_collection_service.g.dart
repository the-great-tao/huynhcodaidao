// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_album_collection_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AudioAlbumCollectionService implements AudioAlbumCollectionService {
  _AudioAlbumCollectionService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://nova.huynhcodaidao.com/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<AudioAlbumCollection> get({path, token, page}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('$path',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': token},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AudioAlbumCollection.fromJson(_result.data);
    return value;
  }
}
