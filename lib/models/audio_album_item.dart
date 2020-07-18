import 'package:json_annotation/json_annotation.dart';

part 'audio_album_item.g.dart';

@JsonSerializable()
class AudioAlbumItem {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'artist')
  String artist;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'icon_url')
  String iconUrl;

  @JsonKey(name: 'audio_url')
  String audioUrl;

  @JsonKey(name: 'action_title')
  String actionTitle;

  @JsonKey(name: 'action_url')
  String actionUrl;

  @JsonKey(name: 'action_type_name')
  String actionTypeName;

  AudioAlbumItem({
    this.id,
    this.title,
    this.artist,
    this.description,
    this.iconUrl,
    this.audioUrl,
    this.actionTitle,
    this.actionUrl,
    this.actionTypeName,
  });

  factory AudioAlbumItem.fromJson(Map<String, dynamic> json) =>
      _$AudioAlbumItemFromJson(json);

  Map<String, dynamic> toJson() => _$AudioAlbumItemToJson(this);
}
