import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/helpers/character_utils.dart';
import 'package:dungeon_paper/db/models/character_settings.dart';
import 'package:dungeon_paper/db/models/converters/character_settings_converter.dart';
import 'package:dungeon_paper/db/models/converters/datetime_converter.dart';
import 'package:dungeon_paper/db/models/converters/default_uuid.dart';
import 'package:dungeon_paper/db/models/converters/dice_converter.dart';
import 'package:dungeon_paper/db/models/converters/document_reference_converter.dart';
import 'package:dungeon_paper/db/models/converters/dw_move_converter.dart';
import 'package:dungeon_paper/db/models/converters/inventory_item_converter.dart';
import 'package:dungeon_paper/db/models/converters/note_converter.dart';
import 'package:dungeon_paper/db/models/converters/player_class_converter.dart';
import 'package:dungeon_paper/db/models/converters/spell_converter.dart';
import 'package:dungeon_paper/db/models/inventory_item.dart';
import 'package:dungeon_paper/db/models/spell.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'note.dart';

part 'character.freezed.dart';
part 'character.g.dart';

@freezed
abstract class Character
    with FirebaseMixin, CharacterFirebaseMixin, KeyMixin
    implements _$Character {
  const Character._();

  @With(FirebaseMixin)
  @With(CharacterFirebaseMixin)
  @With(KeyMixin)
  factory Character({
    @required @DefaultUuid() String key,
    @DocumentReferenceConverter() DocumentReference ref,
    @Default('Traveler') @JsonKey(defaultValue: 'Traveler') String displayName,
    @Default('') @JsonKey(defaultValue: '') String photoURL,
    @DateTimeConverter() DateTime createdAt,
    @DateTimeConverter() DateTime updatedAt,
    @Default(0) @JsonKey(name: 'armor', defaultValue: 0) int baseArmor,
    @Default(8) @JsonKey(name: 'str', defaultValue: 8) int strength,
    @Default(8) @JsonKey(name: 'dex', defaultValue: 8) int dexterity,
    @Default(8) @JsonKey(name: 'con', defaultValue: 8) int constitution,
    @Default(8) @JsonKey(name: 'wis', defaultValue: 8) int wisdom,
    @Default(8) @JsonKey(name: 'int', defaultValue: 8) int intelligence,
    @Default(0) @JsonKey(name: 'cha', defaultValue: 0) int charisma,
    @required @PlayerClassConverter() PlayerClass playerClass,
    @Default(AlignmentName.neutral)
    @JsonKey(defaultValue: AlignmentName.neutral)
        AlignmentName alignment,
    @JsonKey(name: 'maxHP') int customMaxHP,
    @Default(1) @JsonKey(defaultValue: 1) int level,
    @Default('') String bio,
    @Default(100)
    @JsonKey(name: 'currentHP', defaultValue: 100)
        int customCurrentHP,
    @Default(0) @JsonKey(defaultValue: 0) int currentXP,
    @Default([]) @DWMoveConverter() @JsonKey(defaultValue: []) List<Move> moves,
    @Default([]) @NoteConverter() @JsonKey(defaultValue: []) List<Note> notes,
    @Default([])
    @SpellConverter()
    @JsonKey(defaultValue: [])
        List<DbSpell> spells,
    @Default([])
    @InventoryItemConverter()
    @JsonKey(defaultValue: [])
        List<InventoryItem> inventory,
    @DiceConverter() @JsonKey(name: 'hitDice') Dice customDamageDice,
    @Default([]) @JsonKey(defaultValue: []) List<String> looks,
    @DWMoveConverter() @JsonKey(name: 'race') Move raceMove,
    @Default(0) @JsonKey(defaultValue: 0) double coins,
    @Default(0) @JsonKey(defaultValue: 0) int order,
    @JsonKey(name: 'settings')
    @CharacterSettingsConverter()
        CharacterSettings customSettings,
  }) = _Character;

  factory Character.fromJson(value, {DocumentReference ref}) =>
      _$CharacterFromJson(value).copyWith(ref: ref);

  Character copyWithStat(CharacterStat stat, int value) {
    switch (stat) {
      case CharacterStat.str:
        return copyWith(strength: value);
      case CharacterStat.dex:
        return copyWith(dexterity: value);
      case CharacterStat.con:
        return copyWith(constitution: value);
      case CharacterStat.int:
        return copyWith(intelligence: value);
      case CharacterStat.wis:
        return copyWith(wisdom: value);
      case CharacterStat.cha:
        return copyWith(charisma: value);
    }
    throw FormatException(
        'Stat expected, got ${stat.runtimeType} ($stat)', stat, 0);
  }

  @override
  Character get character => this;

  static String getStatUpdateKey(CharacterStat stat) =>
      CHARACTER_STAT_KEYS[stat];

  Dice get damageDice => customDamageDice ?? playerClass?.damage ?? Dice.d6;
  Move get race => raceMove ?? playerClass.raceMoves.first;
  int get currentHP => clamp<int>(customCurrentHP, 0, maxHP).toInt();
  CharacterSettings get settings => customSettings ?? CharacterSettings();

  int get maxHP =>
      (settings.useDefaultMaxHp == true ? defaultMaxHP : customMaxHP) ??
      defaultMaxHP;
  int get defaultMaxHP => (playerClass?.baseHP ?? 0) + constitution;
  int get maxLoad => playerClass.load + strMod;

  static String statModifierText(int stat) {
    var mod = modifierFromValue(stat);
    return (mod >= 0 ? '+' : '') + mod.toString();
  }

  int statValueFromKey(CharacterStat key) {
    switch (key) {
      case CharacterStat.int:
        return intelligence;
      case CharacterStat.dex:
        return dexterity;
      case CharacterStat.wis:
        return wisdom;
      case CharacterStat.cha:
        return charisma;
      case CharacterStat.str:
        return strength;
      case CharacterStat.con:
        return constitution;
      default:
        throw Exception('Bad modifier provided: $key');
    }
  }

  int modifierFromKey(CharacterStat key) {
    switch (key) {
      case CharacterStat.int:
        return modifierFromValue(intelligence);
      case CharacterStat.dex:
        return modifierFromValue(dexterity);
      case CharacterStat.wis:
        return modifierFromValue(wisdom);
      case CharacterStat.cha:
        return modifierFromValue(charisma);
      case CharacterStat.str:
        return modifierFromValue(strength);
      case CharacterStat.con:
        return modifierFromValue(constitution);
      default:
        throw Exception('Bad modifier provided: $key');
    }
  }

  int get strMod => modifierFromValue(strength);
  int get dexMod => modifierFromValue(dexterity);
  int get conMod => modifierFromValue(constitution);
  int get wisMod => modifierFromValue(wisdom);
  int get intMod => modifierFromValue(intelligence);
  int get chaMod => modifierFromValue(charisma);

  CharacterKey modifierKey(String modifierName) =>
      CharacterKey.values.firstWhere(
        (v) => enumName(v) == modifierName,
        orElse: () => null,
      );

  static int modifierFromValue(int stat) {
    const modifiers = {1: -3, 4: -2, 6: -1, 9: 0, 13: 1, 16: 2, 18: 3};

    if (modifiers.containsKey(stat)) {
      return modifiers[stat];
    }

    for (var i = stat; i > 0; --i) {
      if (modifiers.containsKey(i)) {
        return modifiers[i];
      }
    }

    return -1;
  }

  int get armor => equippedArmor + baseArmor;

  double get load => inventory.fold(0, (count, item) => count += item.weight);

  int get equippedArmor => inventory.fold(
      0, (count, item) => count += (item.equipped ? item.armor : 0));

  int get equippedDamage => inventory.fold(
      0, (count, item) => count += (item.equipped ? item.damage : 0));
}

mixin CharacterFirebaseMixin {
  DocumentReference get ref;
  Character get character;
  Map<String, dynamic> toJson();

  Future<DocumentReference> create() async {
    final char = await userController.current.createCharacter(character);
    return char.ref;
  }

  Future<DocumentReference> update({Iterable<String> keys}) {
    characterController.upsert(character);
    return helpers.update(ref, toJson(), keys: keys);
  }

  Future<void> delete() {
    characterController.remove(character);
    return helpers.delete(ref);
  }
}
