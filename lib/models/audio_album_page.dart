import 'package:json_annotation/json_annotation.dart';

import 'package:huynhcodaidao/models/audio_album_item.dart';

part 'audio_album_page.g.dart';

@JsonSerializable()
class AudioAlbumPage {
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
  List<AudioAlbumItem> data;

  AudioAlbumPage({
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

  factory AudioAlbumPage.fromJson(Map<String, dynamic> json) =>
      _$AudioAlbumPageFromJson(json);

  Map<String, dynamic> toJson() => _$AudioAlbumPageToJson(this);
}
