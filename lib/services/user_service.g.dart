// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _UserService implements UserService {
  _UserService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://nova.huynhcodaidao.com/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<UserToken> authenticate(
      {grantType = 'password',
      clientId = 2,
      clientSecret = 'zhxanQ6no1sP6NNYJtjhuGrDmgHbNpUxNKSisQbu',
      username,
      password,
      scope = ''}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'grant_type': grantType,
      'client_id': clientId,
      'client_secret': clientSecret,
      'username': username,
      'password': password,
      'scope': scope
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/oauth/token',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = UserToken.fromJson(_result.data);
    return value;
  }
}
