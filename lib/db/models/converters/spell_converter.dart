import 'package:dungeon_paper/db/models/spell.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class SpellConverter implements JsonConverter<DbSpell, Map<String, dynamic>> {
  const SpellConverter();

  @override
  DbSpell fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return DbSpell.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(DbSpell data) =>
      data?.toJson()?.cast<String, dynamic>();
}
