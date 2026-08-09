// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalizedText _$LocalizedTextFromJson(Map<String, dynamic> json) =>
    LocalizedText(de: json['de'] as String, en: json['en'] as String);

Map<String, dynamic> _$LocalizedTextToJson(LocalizedText instance) =>
    <String, dynamic>{'de': instance.de, 'en': instance.en};

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: json['id'] as String,
  title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
  message: LocalizedText.fromJson(json['message'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String?,
  actions: json['actions'] as List<dynamic>?,
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title.toJson(),
      'message': instance.message.toJson(),
      'imageUrl': instance.imageUrl,
      'actions': instance.actions,
    };
