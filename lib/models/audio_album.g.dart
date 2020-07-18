// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioAlbum _$AudioAlbumFromJson(Map<String, dynamic> json) {
  return AudioAlbum(
    id: json['id'] as int,
    title: json['title'] as String,
    slug: json['slug'] as String,
    defaultIconUrl: json['default_icon_url'] as String,
    audioAlbumPage: json['audio_album_items'] == null
        ? null
        : AudioAlbumPage.fromJson(
            json['audio_album_items'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AudioAlbumToJson(AudioAlbum instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'default_icon_url': instance.defaultIconUrl,
      'audio_album_items': instance.audioAlbumPage,
    };