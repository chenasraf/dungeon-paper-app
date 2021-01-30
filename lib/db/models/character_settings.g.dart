// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CharacterSettings _$_$_CharacterSettingsFromJson(Map<String, dynamic> json) {
  return _$_CharacterSettings(
    useDefaultMaxHp: json['useDefaultMaxHp'] as bool ?? true,
    photoAlignment: const FlutterAlignmentConverter()
        .fromJson(json['photoAlignment'] as String),
  );
}

Map<String, dynamic> _$_$_CharacterSettingsToJson(
        _$_CharacterSettings instance) =>
    <String, dynamic>{
      'useDefaultMaxHp': instance.useDefaultMaxHp,
      'photoAlignment':
          const FlutterAlignmentConverter().toJson(instance.photoAlignment),
    };
