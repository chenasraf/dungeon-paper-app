// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Note _$_$_NoteFromJson(Map<String, dynamic> json) {
  return _$_Note(
    category: json['category'] as String ?? 'Misc',
    key: const DefaultUuid().fromJson(json['key'] as String),
    title: json['title'] as String,
    description: json['description'] as String ?? '',
    tags:
        (json['tags'] as List)?.map(const TagConverter().fromJson)?.toList() ??
            [],
  );
}

Map<String, dynamic> _$_$_NoteToJson(_$_Note instance) => <String, dynamic>{
      'category': instance.category,
      'key': const DefaultUuid().toJson(instance.key),
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags?.map(const TagConverter().toJson)?.toList(),
    };
