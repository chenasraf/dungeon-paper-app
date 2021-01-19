// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Character _$_$_CharacterFromJson(Map<String, dynamic> json) {
  return _$_Character(
    ref: const DocumentReferenceConverter().fromJson(json['ref']),
    key: const DefaultUuid().fromJson(json['key'] as String),
    baseArmor: json['armor'] as int ?? 0,
    strength: json['str'] as int ?? 8,
    dexterity: json['dex'] as int ?? 8,
    constitution: json['con'] as int ?? 8,
    wisdom: json['wis'] as int ?? 8,
    intelligence: json['int'] as int ?? 8,
    charisma: json['cha'] as int ?? 0,
    playerClasses: (json['playerClasses'] as List)
        ?.map((e) =>
            const PlayerClassConverter().fromJson(e as Map<String, dynamic>))
        ?.toList(),
    alignment:
        _$enumDecodeNullable(_$AlignmentNameEnumMap, json['alignment']) ??
            AlignmentName.neutral,
    customMaxHP: json['maxHP'] as int,
    displayName: json['displayName'] as String ?? 'Traveler',
    photoURL: json['photoURL'] as String,
    level: json['level'] as int ?? 1,
    bio: json['bio'] as String ?? '',
    customCurrentHP: json['currentHP'] as int ?? 100,
    currentXP: json['currentXP'] as int,
    moves: (json['moves'] as List)
        ?.map(
            (e) => const DWMoveConverter().fromJson(e as Map<String, dynamic>))
        ?.toList(),
    notes: (json['notes'] as List)
        ?.map((e) => const NoteConverter().fromJson(e as Map<String, dynamic>))
        ?.toList(),
    spells: (json['spells'] as List)
        ?.map((e) => const SpellConverter().fromJson(e as Map<String, dynamic>))
        ?.toList(),
    inventory: (json['inventory'] as List)
        ?.map((e) =>
            const InventoryItemConverter().fromJson(e as Map<String, dynamic>))
        ?.toList(),
    customDamageDice: const DiceConverter().fromJson(json['hitDice']),
    looks: (json['looks'] as List)?.map((e) => e as String)?.toList(),
    race:
        const DWMoveConverter().fromJson(json['race'] as Map<String, dynamic>),
    coins: (json['coins'] as num)?.toDouble() ?? 0,
    order: json['order'] as int,
    settings: const CharacterSettingsConverter()
        .fromJson(json['settings'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_CharacterToJson(_$_Character instance) =>
    <String, dynamic>{
      'ref': const DocumentReferenceConverter().toJson(instance.ref),
      'key': const DefaultUuid().toJson(instance.key),
      'armor': instance.baseArmor,
      'str': instance.strength,
      'dex': instance.dexterity,
      'con': instance.constitution,
      'wis': instance.wisdom,
      'int': instance.intelligence,
      'cha': instance.charisma,
      'playerClasses': instance.playerClasses
          ?.map(const PlayerClassConverter().toJson)
          ?.toList(),
      'alignment': _$AlignmentNameEnumMap[instance.alignment],
      'maxHP': instance.customMaxHP,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'level': instance.level,
      'bio': instance.bio,
      'currentHP': instance.customCurrentHP,
      'currentXP': instance.currentXP,
      'moves': instance.moves?.map(const DWMoveConverter().toJson)?.toList(),
      'notes': instance.notes?.map(const NoteConverter().toJson)?.toList(),
      'spells': instance.spells?.map(const SpellConverter().toJson)?.toList(),
      'inventory': instance.inventory
          ?.map(const InventoryItemConverter().toJson)
          ?.toList(),
      'hitDice': const DiceConverter().toJson(instance.customDamageDice),
      'looks': instance.looks,
      'race': const DWMoveConverter().toJson(instance.race),
      'coins': instance.coins,
      'order': instance.order,
      'settings': const CharacterSettingsConverter().toJson(instance.settings),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$AlignmentNameEnumMap = {
  AlignmentName.good: 'good',
  AlignmentName.lawful: 'lawful',
  AlignmentName.neutral: 'neutral',
  AlignmentName.chaotic: 'chaotic',
  AlignmentName.evil: 'evil',
};
