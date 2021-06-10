import 'package:json_annotation/json_annotation.dart';

part 'message_style.g.dart';

@JsonSerializable()
class MessageStyle {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'slug')
  String slug;

  @JsonKey(name: 'list_background_color')
  String listBackgroundColor;

  @JsonKey(name: 'list_separator_color')
  String listSeparatorColor;

  @JsonKey(name: 'container_background_color')
  String containerBackgroundColor;

  @JsonKey(name: 'container_border_color')
  String containerBorderColor;

  @JsonKey(name: 'badge_background_color')
  String badgeBackgroundColor;

  @JsonKey(name: 'badge_text_color')
  String badgeTextColor;

  @JsonKey(name: 'date_text_color')
  String dateTextColor;

  @JsonKey(name: 'title_text_color')
  String titleTextColor;

  @JsonKey(name: 'content_text_color')
  String contentTextColor;

  @JsonKey(name: 'summary_text_color')
  String summaryTextColor;

  @JsonKey(name: 'primary_icon_url')
  String primaryIconUrl;

  @JsonKey(name: 'secondary_icon_url')
  String secondaryIconUrl;

  @JsonKey(name: 'read_more_icon_url')
  String readMoreIconUrl;

  MessageStyle({
    this.id,
    this.title,
    this.slug,
    this.listBackgroundColor,
    this.listSeparatorColor,
    this.containerBackgroundColor,
    this.containerBorderColor,
    this.badgeBackgroundColor,
    this.badgeTextColor,
    this.dateTextColor,
    this.titleTextColor,
    this.contentTextColor,
    this.summaryTextColor,
    this.primaryIconUrl,
    this.secondaryIconUrl,
    this.readMoreIconUrl,
  });

  factory MessageStyle.fromJson(Map<String, dynamic> json) =>
      _$MessageStyleFromJson(json);

  Map<String, dynamic> toJson() => _$MessageStyleToJson(this);
}
