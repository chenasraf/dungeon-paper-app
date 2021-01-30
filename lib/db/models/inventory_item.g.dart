// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InventoryItem _$_$_InventoryItemFromJson(Map<String, dynamic> json) {
  return _$_InventoryItem(
    key: const DefaultUuid().fromJson(json['key'] as String),
    name: json['name'] as String,
    pluralName: json['pluralName'] as String,
    description: json['description'] as String ?? '',
    tags:
        (json['tags'] as List)?.map(const TagConverter().fromJson)?.toList() ??
            [],
    amount: json['amount'] as num ?? 1,
    equipped: json['equipped'] as bool ?? false,
    countWeight: json['countWeight'] as bool ?? true,
    countDamage: json['countDamage'] as bool ?? true,
    countArmor: json['countArmor'] as bool ?? true,
  );
}

Map<String, dynamic> _$_$_InventoryItemToJson(_$_InventoryItem instance) =>
    <String, dynamic>{
      'key': const DefaultUuid().toJson(instance.key),
      'name': instance.name,
      'pluralName': instance.pluralName,
      'description': instance.description,
      'tags': instance.tags?.map(const TagConverter().toJson)?.toList(),
      'amount': instance.amount,
      'equipped': instance.equipped,
      'countWeight': instance.countWeight,
      'countDamage': instance.countDamage,
      'countArmor': instance.countArmor,
    };
