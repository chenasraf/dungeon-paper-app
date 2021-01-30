import 'package:dungeon_paper/db/models/converters/flutter_alignment_converter.dart';
import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_settings.g.dart';
part 'character_settings.freezed.dart';

@freezed
abstract class CharacterSettings implements _$CharacterSettings {
  const CharacterSettings._();

  const factory CharacterSettings({
    @Default(true) bool useDefaultMaxHp,
    @FlutterAlignmentConverter() Alignment photoAlignment,
  }) = _CharacterSettings;

  factory CharacterSettings.fromJson(json) => _$CharacterSettingsFromJson(json);
}
