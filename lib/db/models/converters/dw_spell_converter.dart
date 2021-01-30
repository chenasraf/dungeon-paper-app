import 'package:dungeon_world_data/spell.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DWSpellConverter implements JsonConverter<Spell, Map<String, dynamic>> {
  const DWSpellConverter();

  @override
  Spell fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Spell.fromJSON(json);
  }

  @override
  Map<String, dynamic> toJson(Spell data) =>
      data?.toJSON()?.cast<String, dynamic>();
}
