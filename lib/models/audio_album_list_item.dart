import 'package:json_annotation/json_annotation.dart';

part 'audio_album_list_item.g.dart';

@JsonSerializable()
class AudioAlbumListItem {
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

  AudioAlbumListItem({
    this.id,
    this.title,
    this.slug,
    this.coverUrl,
    this.actionTitle,
    this.actionUrl,
    this.actionTypeName,
  });

  factory AudioAlbumListItem.fromJson(Map<String, dynamic> json) =>
      _$AudioAlbumListItemFromJson(json);

  Map<String, dynamic> toJson() => _$AudioAlbumListItemToJson(this);
}
