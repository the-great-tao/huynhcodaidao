// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_album_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioAlbumList _$AudioAlbumListFromJson(Map<String, dynamic> json) {
  return AudioAlbumList(
    currentPage: json['current_page'] as int,
    lastPage: json['last_page'] as int,
    perPage: json['per_page'] as int,
    total: json['total'] as int,
    from: json['from'] as int,
    to: json['to'] as int,
    path: json['path'] as String,
    firstPageUrl: json['first_page_url'] as String,
    lastPageUrl: json['last_page_url'] as String,
    prevPageUrl: json['prev_page_url'] as String,
    nextPageUrl: json['next_page_url'] as String,
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : AudioAlbumListItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AudioAlbumListToJson(AudioAlbumList instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'from': instance.from,
      'to': instance.to,
      'path': instance.path,
      'first_page_url': instance.firstPageUrl,
      'last_page_url': instance.lastPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'data': instance.data,
    };
