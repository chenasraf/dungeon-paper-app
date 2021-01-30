// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DbSpell _$_$_DbSpellFromJson(Map<String, dynamic> json) {
  return _$_DbSpell(
    key: const DefaultUuid().fromJson(json['key'] as String),
    name: json['name'] as String,
    description: json['description'] as String ?? '',
    level: json['level'] as String,
    tags:
        (json['tags'] as List)?.map(const TagConverter().fromJson)?.toList() ??
            [],
    prepared: json['prepared'] as bool ?? false,
  );
}

Map<String, dynamic> _$_$_DbSpellToJson(_$_DbSpell instance) =>
    <String, dynamic>{
      'key': const DefaultUuid().toJson(instance.key),
      'name': instance.name,
      'description': instance.description,
      'level': instance.level,
      'tags': instance.tags?.map(const TagConverter().toJson)?.toList(),
      'prepared': instance.prepared,
    };
