import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_group.g.dart';

@JsonSerializable()
class PlayerGroup extends Equatable {
  const PlayerGroup({required this.playerNames});

  final List<String> playerNames;

  factory PlayerGroup.fromJson(Map<String, dynamic> json) =>
      _$PlayerGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerGroupToJson(this);

  @override
  List<Object?> get props => [playerNames];
}
