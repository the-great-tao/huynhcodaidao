import 'package:json_annotation/json_annotation.dart';

part 'photo_album.g.dart';

@JsonSerializable()
class PhotoAlbum {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'slug')
  String slug;

  @JsonKey(name: 'cover_url')
  String coverUrl;

  @JsonKey(name: 'action_title')
  String actionTitle;

  @JsonKey(name: 'action_url')
  String actionUrl;

  @JsonKey(name: 'action_type_name')
  String actionTypeName;

  PhotoAlbum({
    this.id,
    this.title,
    this.slug,
    this.coverUrl,
    this.actionTitle,
    this.actionUrl,
    this.actionTypeName,
  });

  factory PhotoAlbum.fromJson(Map<String, dynamic> json) =>
      _$PhotoAlbumFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoAlbumToJson(this);
}
