import 'package:json_annotation/json_annotation.dart';

import 'package:huynhcodaidao/modules/message/message.dart';

part 'message_list.g.dart';

@JsonSerializable()
class MessageList {
  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'last_page')
  int lastPage;

  @JsonKey(name: 'per_page')
  int perPage;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'from')
  int from;

  @JsonKey(name: 'to')
  int to;

  @JsonKey(name: 'path')
  String path;

  @JsonKey(name: 'first_page_url')
  String firstPageUrl;

  @JsonKey(name: 'last_page_url')
  String lastPageUrl;

  @JsonKey(name: 'prev_page_url')
  String prevPageUrl;

  @JsonKey(name: 'next_page_url')
  String nextPageUrl;

  @JsonKey(name: 'data')
  List<Message> data;

  MessageList({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
    this.path,
    this.firstPageUrl,
    this.lastPageUrl,
    this.prevPageUrl,
    this.nextPageUrl,
    this.data,
  });

  factory MessageList.fromJson(Map<String, dynamic> json) =>
      _$MessageListFromJson(json);

  Map<String, dynamic> toJson() => _$MessageListToJson(this);
}
