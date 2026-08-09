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

enum AnnouncementActionType { navigate, dismiss }

@JsonSerializable()
class AnnouncementAction extends Equatable {
  const AnnouncementAction({
    required this.type,
    required this.label,
    this.route,
  });

  @JsonKey(
    defaultValue: AnnouncementActionType.dismiss,
    unknownEnumValue: AnnouncementActionType.dismiss,
  )
  final AnnouncementActionType type;
  final LocalizedText label;
  final String? route;

  factory AnnouncementAction.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementActionFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementActionToJson(this);

  @override
  List<Object?> get props => [type, label, route];
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
  final List<AnnouncementAction>? actions;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  @override
  List<Object?> get props => [id, title, message, imageUrl, actions];
}
