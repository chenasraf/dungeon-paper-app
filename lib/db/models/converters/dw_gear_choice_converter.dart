import 'package:dungeon_world_data/gear_choice.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DWGearChoiceConverter
    implements JsonConverter<GearChoice, Map<String, dynamic>> {
  const DWGearChoiceConverter();

  @override
  GearChoice fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return GearChoice.fromJSON(json);
  }

  @override
  Map<String, dynamic> toJson(GearChoice data) =>
      data?.toJSON()?.cast<String, dynamic>();
}
