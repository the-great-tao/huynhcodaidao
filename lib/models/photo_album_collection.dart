import 'package:json_annotation/json_annotation.dart';

import 'package:huynhcodaidao/models/banner.dart';
import 'package:huynhcodaidao/models/photo_album_list.dart';

part 'photo_album_collection.g.dart';

@JsonSerializable()
class PhotoAlbumCollection {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'slug')
  String slug;

  @JsonKey(name: 'default_icon_url')
  String defaultIconUrl;

  @JsonKey(name: 'banner')
  Banner banner;

  @JsonKey(name: 'photo_albums')
  PhotoAlbumList photoAlbumList;

  PhotoAlbumCollection({
    this.id,
    this.title,
    this.slug,
    this.defaultIconUrl,
    this.banner,
    this.photoAlbumList,
  });

  factory PhotoAlbumCollection.fromJson(Map<String, dynamic> json) =>
      _$PhotoAlbumCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoAlbumCollectionToJson(this);
}
