import 'package:dungeon_world_data/move.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DWMoveConverter implements JsonConverter<Move, Map<String, dynamic>> {
  const DWMoveConverter();

  @override
  Move fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Move.fromJSON(json);
  }

  @override
  Map<String, dynamic> toJson(Move data) =>
      data?.toJSON()?.cast<String, dynamic>();
}
