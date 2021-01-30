import 'package:dungeon_world_data/alignment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DWAlignmentConverter
    implements JsonConverter<Alignment, Map<dynamic, dynamic>> {
  const DWAlignmentConverter();

  @override
  Alignment fromJson(Map<dynamic, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Alignment.fromJSON(json);
  }

  @override
  Map<dynamic, dynamic> toJson(Alignment data) =>
      data.toJSON().cast<dynamic, dynamic>();
}
