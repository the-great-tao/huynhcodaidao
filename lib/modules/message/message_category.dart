import 'package:json_annotation/json_annotation.dart';

import 'package:huynhcodaidao/models/banner.dart';
import 'package:huynhcodaidao/modules/message/message_list.dart';
import 'package:huynhcodaidao/modules/message/message_style.dart';

part 'message_category.g.dart';

@JsonSerializable()
class MessageCategory {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'slug')
  String slug;

  @JsonKey(name: 'banner')
  Banner banner;

  @JsonKey(name: 'messages')
  MessageList messages;

  @JsonKey(name: 'default_style')
  MessageStyle defaultStyle;

  MessageCategory({
    this.id,
    this.title,
    this.slug,
    this.banner,
    this.messages,
    this.defaultStyle,
  });

  factory MessageCategory.fromJson(Map<String, dynamic> json) =>
      _$MessageCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MessageCategoryToJson(this);
}
