import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class LocalizedText extends Equatable {
  const LocalizedText({required this.de, required this.en});

  final String de;
  final String en;

  factory LocalizedText.fromJson(Map<String, dynamic> json) =>
      _$LocalizedTextFromJson(json);

  Map<String, dynamic> toJson() => _$LocalizedTextToJson(this);

  @override
  List<Object?> get props => [de, en];
}

@JsonSerializable()
class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    this.actions,
  });

  final String id;
  final LocalizedText title;
  final LocalizedText message;
  final String? imageUrl;
  final List<dynamic>? actions;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  @override
  List<Object?> get props => [id, title, message, imageUrl, actions];
}
