// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Campaign _$_$_CampaignFromJson(Map<String, dynamic> json) {
  return _$_Campaign(
    key: const DefaultUuid().fromJson(json['key'] as String),
    ref: const DocumentReferenceConverter().fromJson(json['ref']),
    createdAt: const DateTimeConverter().fromJson(json['createdAt']),
    updatedAt: const DateTimeConverter().fromJson(json['updatedAt']),
    name: json['name'] as String ?? 'Our Campaign',
    description: json['description'] as String ?? '',
    owner: json['owner'] == null ? null : User.fromJson(json['owner']),
    characterRefs: (json['characters'] as List)
        ?.map(const DocumentReferenceConverter().fromJson)
        ?.toList(),
  );
}

Map<String, dynamic> _$_$_CampaignToJson(_$_Campaign instance) =>
    <String, dynamic>{
      'key': const DefaultUuid().toJson(instance.key),
      'ref': const DocumentReferenceConverter().toJson(instance.ref),
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
      'name': instance.name,
      'description': instance.description,
      'owner': instance.owner,
      'characters': instance.characterRefs
          ?.map(const DocumentReferenceConverter().toJson)
          ?.toList(),
    };
