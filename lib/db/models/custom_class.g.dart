// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CustomClass _$_$_CustomClassFromJson(Map<String, dynamic> json) {
  return _$_CustomClass(
    key: const DefaultUuid().fromJson(json['key'] as String),
    ref: const DocumentReferenceConverter().fromJson(json['ref']),
    createdAt: const DateTimeConverter().fromJson(json['createdAt']),
    updatedAt: const DateTimeConverter().fromJson(json['updatedAt']),
    name: json['name'] as String ?? '',
    description: json['description'] as String ?? '',
    load: json['load'] as num ?? 0,
    baseHP: json['baseHP'] as num ?? 0,
    damage: const DiceConverter().fromJson(json['damage']),
    names: (json['names'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
        ) ??
        {},
    bonds: (json['bonds'] as List)?.map((e) => e as String)?.toList() ?? [],
    looks: (json['looks'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
        ) ??
        {},
    alignments: (json['alignments'] as Map<String, dynamic>)?.map(
          (k, e) =>
              MapEntry(k, const DWAlignmentConverter().fromJson(e as Map)),
        ) ??
        {},
    raceMoves: (json['raceMoves'] as List)
            ?.map((e) =>
                const DWMoveConverter().fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    startingMoves: (json['startingMoves'] as List)
            ?.map((e) =>
                const DWMoveConverter().fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    advancedMoves1: (json['advancedMoves1'] as List)
            ?.map((e) =>
                const DWMoveConverter().fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    advancedMoves2: (json['advancedMoves2'] as List)
            ?.map((e) =>
                const DWMoveConverter().fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    spells: (json['spells'] as List)
        ?.map(
            (e) => const DWSpellConverter().fromJson(e as Map<String, dynamic>))
        ?.toList(),
    gearChoices: (json['gearChoices'] as List)
            ?.map((e) => const DWGearChoiceConverter()
                .fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$_$_CustomClassToJson(_$_CustomClass instance) =>
    <String, dynamic>{
      'key': const DefaultUuid().toJson(instance.key),
      'ref': const DocumentReferenceConverter().toJson(instance.ref),
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
      'name': instance.name,
      'description': instance.description,
      'load': instance.load,
      'baseHP': instance.baseHP,
      'damage': const DiceConverter().toJson(instance.damage),
      'names': instance.names,
      'bonds': instance.bonds,
      'looks': instance.looks,
      'alignments': instance.alignments
          ?.map((k, e) => MapEntry(k, const DWAlignmentConverter().toJson(e))),
      'raceMoves':
          instance.raceMoves?.map(const DWMoveConverter().toJson)?.toList(),
      'startingMoves':
          instance.startingMoves?.map(const DWMoveConverter().toJson)?.toList(),
      'advancedMoves1': instance.advancedMoves1
          ?.map(const DWMoveConverter().toJson)
          ?.toList(),
      'advancedMoves2': instance.advancedMoves2
          ?.map(const DWMoveConverter().toJson)
          ?.toList(),
      'spells': instance.spells?.map(const DWSpellConverter().toJson)?.toList(),
      'gearChoices': instance.gearChoices
          ?.map(const DWGearChoiceConverter().toJson)
          ?.toList(),
    };
