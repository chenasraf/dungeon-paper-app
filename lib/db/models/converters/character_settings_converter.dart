import 'package:dungeon_paper/db/models/character_settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class CharacterSettingsConverter
    implements JsonConverter<CharacterSettings, Map<String, dynamic>> {
  const CharacterSettingsConverter();

  @override
  CharacterSettings fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return CharacterSettings();
    }
    return CharacterSettings.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CharacterSettings data) =>
      (data ?? CharacterSettings()).toJson();
}
