import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_service.g.dart';

@RestApi(baseUrl: "https://nova.huynhcodaidao.com/")
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @POST("/oauth/token")
  Future<UserToken> authenticate({
    @Field('grant_type') String grantType = 'password',
    @Field('client_id') int clientId = 2,
    @Field('client_secret')
        String clientSecret = 'zhxanQ6no1sP6NNYJtjhuGrDmgHbNpUxNKSisQbu',
    @Field('username') String username,
    @Field('password') String password,
    @Field('scope') String scope = '',
  });
}

@HiveType(typeId: 0)
@JsonSerializable()
class UserToken {
  @HiveField(0)
  @JsonKey(name: 'token_type')
  String tokenType;

  @HiveField(1)
  @JsonKey(name: 'expires_in')
  int expiresIn;

  @HiveField(2)
  @JsonKey(name: 'access_token')
  String accessToken;

  @HiveField(3)
  @JsonKey(name: 'refresh_token')
  String refreshToken;

  UserToken({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) =>
      _$UserTokenFromJson(json);

  Map<String, dynamic> toJson() => _$UserTokenToJson(this);
}
