import 'package:json_annotation/json_annotation.dart';

import 'package:huynhcodaidao/modules/message/message_style.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'slug')
  String slug;

  @JsonKey(name: 'image_url')
  String imageUrl;

  @JsonKey(name: 'badge')
  String badge;

  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'content_type')
  String contentType;

  @JsonKey(name: 'content')
  String content;

  @JsonKey(name: 'summary')
  String summary;

  @JsonKey(name: 'note')
  String note;

  @JsonKey(name: 'custom_style')
  MessageStyle customStyle;

  @JsonKey(name: 'action_title')
  String actionTitle;

  @JsonKey(name: 'action_url')
  String actionUrl;

  @JsonKey(name: 'action_type_name')
  String actionTypeName;

  Message({
    this.id,
    this.title,
    this.slug,
    this.imageUrl,
    this.badge,
    this.date,
    this.contentType,
    this.content,
    this.summary,
    this.note,
    this.customStyle,
    this.actionTitle,
    this.actionUrl,
    this.actionTypeName,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
