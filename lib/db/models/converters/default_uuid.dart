import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

class DefaultUuid implements JsonConverter<String, String> {
  const DefaultUuid();

  @override
  String fromJson(String json) {
    if (json is String && json.isNotEmpty) {
      return json;
    }

    return Uuid().v4();
  }

  @override
  String toJson(String data) => data ?? Uuid().v4();
}
