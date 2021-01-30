import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/models/converters/default_uuid.dart';
import 'package:dungeon_paper/db/models/converters/tag_converter.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/equipment.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'character.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

enum EquipmentKeys { key, item, amount }

@freezed
abstract class InventoryItem with KeyMixin implements _$InventoryItem {
  const InventoryItem._();

  const factory InventoryItem({
    @required @DefaultUuid() String key,
    @required String name,
    String pluralName,
    @Default('') String description,
    @TagConverter() @Default([]) List<Tag> tags,
    @Default(1) num amount,
    @Default(false) bool equipped,
    @Default(true) bool countWeight,
    @Default(true) bool countDamage,
    @Default(true) bool countArmor,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(value) => _$InventoryItemFromJson(value);

  static InventoryItem fromEquipment(
    Equipment equipment, {
    int amount = 1,
    bool equipped = false,
    bool countWeight = true,
    bool countDamage = true,
    bool countArmor = true,
  }) =>
      _$InventoryItemFromJson({
        ...equipment.toJSON(),
        'amount': amount ?? 1,
        'equipped': equipped ?? false,
        'countWeight': countWeight ?? true,
        'countDamage': countDamage ?? true,
        'countArmor': countArmor ?? true,
      });

  bool get hasDamage =>
      tags?.firstWhere(
        (t) => t?.name?.toLowerCase() == 'damage',
        orElse: () => null,
      ) !=
      null;

  bool get hasWeight =>
      tags?.firstWhere(
        (t) => t?.name?.toLowerCase() == 'weight',
        orElse: () => null,
      ) !=
      null;

  bool get hasArmor =>
      tags?.firstWhere(
        (t) => t?.name?.toLowerCase() == 'armor',
        orElse: () => null,
      ) !=
      null;

  int get armor {
    if (!countArmor) {
      return 0;
    }

    final armor = tags?.firstWhere(
      (t) => t?.name?.toLowerCase() == 'armor',
      orElse: () => null,
    );
    if (armor != null && armor.hasValue) {
      var armorValue = 0;
      if (armor.value is num) {
        armorValue += armor.value;
      } else {
        armorValue += int.tryParse(armor.value ?? '0') ?? 0.0;
      }
      return armorValue * amount;
    }
    return 0;
  }

  double get weight {
    if (!countWeight) {
      return 0;
    }

    final armor = tags?.firstWhere(
      (t) => t?.name?.toLowerCase() == 'weight',
      orElse: () => null,
    );
    if (armor != null && armor.hasValue) {
      var weightValue = 0.toDouble();
      if (armor.value is num) {
        weightValue += armor.value;
      } else {
        weightValue += double.tryParse(armor.value ?? '0') ?? 0.0;
      }
      return weightValue * amount;
    }
    return 0;
  }

  int get damage {
    if (!countDamage) {
      return 0;
    }

    final damage = tags?.firstWhere(
      (t) => t?.name?.toLowerCase() == 'damage',
      orElse: () => null,
    );
    if (damage != null && damage.hasValue) {
      var damageValue = 0;
      if (damage.value is num) {
        damageValue += damage.value;
      } else {
        damageValue += int.tryParse(damage.value ?? 0) ?? 0;
      }
      return damageValue;
    }
    return 0;
  }
}

ReturnPredicate<InventoryItem> invItemMatcher = matcher(
    (InventoryItem i, InventoryItem o) => i.key != null && i.key == o.key);

Future<void> updateInventoryItem(
        Character character, InventoryItem item) async =>
    character
        .copyWith(inventory: findAndReplaceInList(character.inventory, item))
        .update(keys: ['inventory']);

Future<void> deleteInventoryItem(
        Character character, InventoryItem item) async =>
    character
        .copyWith(inventory: removeFromList(character.inventory, item))
        .update(keys: ['inventory']);

Future<void> createInventoryItem(
    Character character, InventoryItem item) async {
  final found = character.inventory
      .firstWhere((it) => it.name == item.name, orElse: () => null);
  if (found != null) {
    return character
        .copyWith(
      inventory: findAndReplaceInList(
        character.inventory,
        found.copyWith(amount: found.amount + 1),
      ),
    )
        .update(keys: ['inventory']);
  }
  return character
      .copyWith(inventory: addToList(character.inventory, item))
      .update(keys: ['inventory']);
}

Future<void> incrItemAmount(
  Character character,
  InventoryItem item,
  num amount,
) async =>
    character.copyWith(
      inventory: findAndReplaceInList(
        character.inventory,
        item.copyWith(amount: item.amount + amount),
      ),
    );
