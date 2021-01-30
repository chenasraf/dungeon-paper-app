import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class PlayerClassConverter
    implements JsonConverter<PlayerClass, Map<String, dynamic>> {
  const PlayerClassConverter();

  @override
  PlayerClass fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return dungeonWorld.classes.first;
    }
    if (json['looks'] is Map) {
      json['looks'] = json['looks'].values.toList();
    }
    return PlayerClass.fromJSON(json);
  }

  @override
  Map<String, dynamic> toJson(PlayerClass data) {
    final json = data.toJSON().cast<String, dynamic>();
    if (json['looks'] is List) {
      json['looks'] = (json['looks'] as List<List<String>>)
          .asMap()
          .map((k, v) => MapEntry<String, List<String>>(k.toString(), v));
    }
    return json;
  }
}
