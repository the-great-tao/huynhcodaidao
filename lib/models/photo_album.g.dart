// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoAlbum _$PhotoAlbumFromJson(Map<String, dynamic> json) {
  return PhotoAlbum(
    id: json['id'] as int,
    title: json['title'] as String,
    slug: json['slug'] as String,
    photoAlbumPage: json['photo_album_items'] == null
        ? null
        : PhotoAlbumPage.fromJson(
            json['photo_album_items'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PhotoAlbumToJson(PhotoAlbum instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'photo_album_items': instance.photoAlbumPage,
    };
