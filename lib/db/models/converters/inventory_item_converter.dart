import 'package:dungeon_paper/db/models/inventory_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class InventoryItemConverter
    implements JsonConverter<InventoryItem, Map<String, dynamic>> {
  const InventoryItemConverter();

  @override
  InventoryItem fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return InventoryItem.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(InventoryItem data) => data.toJson();
}
