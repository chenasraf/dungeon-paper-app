import 'package:dungeon_world_data/tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TagConverter implements JsonConverter<Tag, dynamic> {
  const TagConverter();

  @override
  Tag fromJson(dynamic json) {
    if (json == null) {
      return null;
    }

    if (json is Tag) {
      return json;
    }

    return Tag.fromJSON(json);
  }

  @override
  dynamic toJson(Tag data) => data?.toJSON();
}
