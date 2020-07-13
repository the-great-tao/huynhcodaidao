import 'package:json_annotation/json_annotation.dart';

import 'package:huynhcodaidao/models/banner.dart';
import 'package:huynhcodaidao/models/audio_album_list.dart';

part 'audio_album_collection.g.dart';

@JsonSerializable()
class AudioAlbumCollection {
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

  @JsonKey(name: 'audio_albums')
  AudioAlbumList audioAlbumList;

  AudioAlbumCollection({
    this.id,
    this.title,
    this.slug,
    this.defaultIconUrl,
    this.banner,
    this.audioAlbumList,
  });

  factory AudioAlbumCollection.fromJson(Map<String, dynamic> json) =>
      _$AudioAlbumCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$AudioAlbumCollectionToJson(this);
}
