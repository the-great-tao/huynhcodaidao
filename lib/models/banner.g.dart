// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banner _$BannerFromJson(Map<String, dynamic> json) {
  return Banner(
    id: json['id'] as int,
    title: json['title'] as String,
    slug: json['slug'] as String,
    url: json['url'] as String,
    actionTitle: json['action_title'] as String,
    actionUrl: json['action_url'] as String,
    actionTypeName: json['action_type_name'] as String,
  );
}

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'url': instance.url,
      'action_title': instance.actionTitle,
      'action_url': instance.actionUrl,
      'action_type_name': instance.actionTypeName,
    };