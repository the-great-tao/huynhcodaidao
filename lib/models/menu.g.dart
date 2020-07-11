// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    id: json['id'] as int,
    title: json['title'] as String,
    slug: json['slug'] as String,
    defaultIconUrl: json['default_icon_url'] as String,
    bellUrl: json['bell_url'] as String,
    hotAlbumUrl: json['hot_album_url'] as String,
    banner: json['banner'] == null
        ? null
        : Banner.fromJson(json['banner'] as Map<String, dynamic>),
    menuItemList: json['menu_items'] == null
        ? null
        : MenuItemList.fromJson(json['menu_items'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'default_icon_url': instance.defaultIconUrl,
      'bell_url': instance.bellUrl,
      'hot_album_url': instance.hotAlbumUrl,
      'banner': instance.banner,
      'menu_items': instance.menuItemList,
    };
