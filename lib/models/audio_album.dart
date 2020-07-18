import 'package:json_annotation/json_annotation.dart';

import 'package:huynhcodaidao/models/audio_album_page.dart';

part 'audio_album.g.dart';

@JsonSerializable()
class AudioAlbum {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'slug')
  String slug;

  @JsonKey(name: 'default_icon_url')
  String defaultIconUrl;

  @JsonKey(name: 'audio_album_items')
  AudioAlbumPage audioAlbumPage;

  AudioAlbum({
    this.id,
    this.title,
    this.slug,
    this.defaultIconUrl,
    this.audioAlbumPage,
  });

  factory AudioAlbum.fromJson(Map<String, dynamic> json) =>
      _$AudioAlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AudioAlbumToJson(this);
}
