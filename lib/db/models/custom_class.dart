import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/models/converters/datetime_converter.dart';
import 'package:dungeon_paper/db/models/converters/default_uuid.dart';
import 'package:dungeon_paper/db/models/converters/dice_converter.dart';
import 'package:dungeon_paper/db/models/converters/document_reference_converter.dart';
import 'package:dungeon_paper/db/models/converters/dw_alignment_converter.dart';
import 'package:dungeon_paper/db/models/converters/dw_gear_choice_converter.dart';
import 'package:dungeon_paper/db/models/converters/dw_move_converter.dart';
import 'package:dungeon_paper/db/models/converters/dw_spell_converter.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/alignment.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:dungeon_world_data/gear_choice.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:dungeon_world_data/spell.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_class.freezed.dart';
part 'custom_class.g.dart';

@freezed
abstract class CustomClass
    with FirebaseMixin, CustomClassFirebaseMixin, KeyMixin
    implements _$CustomClass {
  const CustomClass._();

  @With(FirebaseMixin)
  @With(CustomClassFirebaseMixin)
  @With(KeyMixin)
  const factory CustomClass({
    @required @DefaultUuid() String key,
    @DocumentReferenceConverter() DocumentReference ref,
    @DateTimeConverter() DateTime createdAt,
    @DateTimeConverter() DateTime updatedAt,
    @Default('') @JsonKey(defaultValue: '') String name,
    @Default('') @JsonKey(defaultValue: '') String description,
    @Default(0) @JsonKey(defaultValue: 0) num load,
    @Default(0) @JsonKey(defaultValue: 0) num baseHP,
    @DiceConverter() Dice damage,
    @Default({}) @JsonKey(defaultValue: {}) Map<String, List<String>> names,
    @Default([]) @JsonKey(defaultValue: []) List<String> bonds,
    @Default({}) @JsonKey(defaultValue: {}) Map<String, List<String>> looks,
    @Default({})
    @JsonKey(defaultValue: {})
    @DWAlignmentConverter()
        Map<String, Alignment> alignments,
    @Default([])
    @JsonKey(defaultValue: [])
    @DWMoveConverter()
        List<Move> raceMoves,
    @Default([])
    @JsonKey(defaultValue: [])
    @DWMoveConverter()
        List<Move> startingMoves,
    @Default([])
    @JsonKey(defaultValue: [])
    @DWMoveConverter()
        List<Move> advancedMoves1,
    @Default([])
    @JsonKey(defaultValue: [])
    @DWMoveConverter()
        List<Move> advancedMoves2,
    @DWSpellConverter() List<Spell> spells,
    @Default([])
    @JsonKey(defaultValue: [])
    @DWGearChoiceConverter()
        List<GearChoice> gearChoices,
  }) = _CustomClass;

  factory CustomClass.fromJson(Map<String, dynamic> json,
          {DocumentReference ref}) =>
      _$CustomClassFromJson(json).copyWith(ref: ref);

  static CustomClass fromPlayerClass(
    PlayerClass playerClass, {
    DocumentReference ref,
    bool retainKey = false,
  }) =>
      CustomClass.fromJson(
              _copyPlayerClsData(playerClass, retainKey: retainKey))
          .copyWith(ref: ref);

  static Map<String, dynamic> _copyPlayerClsData(
    PlayerClass playerClass, {
    bool retainKey = false,
  }) {
    final json =
        playerClass.toJSON().map((k, v) => MapEntry(snakeToCamel(k), v));
    json['looks'] = Map<String, dynamic>.from(
      ((json['looks'] ?? []) as List<List<String>>).asMap().map(
            (k, v) => MapEntry(k.toString(), v),
          ),
    );
    json['baseHP'] = json.remove('baseHp');
    if (!retainKey) {
      json.remove('key');
    }
    json.forEach((key, value) {
      if (value is Map) {
        json[key] = Map<String, dynamic>.from(value);
        json[key].forEach((key2, value2) {
          if (value2 is! Map) {
            return;
          }
          json[key][key2] = Map<String, dynamic>.from(value2);
        });
      } else if (value is List<Map>) {
        json[key] = List<Map<String, dynamic>>.from(
          value.map((e) => e?.cast<String, dynamic>()),
        );
        enumerate(json[key]).forEach((value2) {
          if (value2 is Map) {
            json[key][value2.index] = Map<String, dynamic>.from(value2.value);
          }
        });
      }
    });
    return Map<String, dynamic>.from(json);
  }

  @override
  CustomClass get customClass => this;

  @override
  PlayerClass toPlayerClass() {
    final data = Map<String, dynamic>.from(
      toJson().map((k, v) => MapEntry(camelToSnake(k), v)),
    );
    data['looks'] = looks.values.toList();
    return PlayerClass.fromJSON(data);
  }
}

mixin CustomClassFirebaseMixin {
  DocumentReference get ref;
  CustomClass get customClass;
  Map<String, dynamic> toJson();
  PlayerClass toPlayerClass();

  Future<DocumentReference> create() async {
    final cls = await userController.current.createCustomClass(customClass);
    return cls.ref;
  }

  Future<DocumentReference> update({Iterable<String> keys}) async {
    customClassesController.upsert(customClass);
    await _updateChars();
    final ref = await helpers.update(this.ref, toJson(), keys: keys);
    return ref;
  }

  Future<void> delete() async {
    customClassesController.remove(customClass);
    return helpers.delete(ref);
  }

  Future<void> _updateChars() async {
    final futures = <Future>[];
    for (final char in characterController.all.values) {
      if (char.playerClasses.any((el) => el.key == customClass.key)) {
        final _updated = char.playerClasses
            .map((el) => el.key == customClass.key ? toPlayerClass() : el)
            .toList();
        futures.add(
          char.copyWith(playerClasses: _updated).update(
            keys: ['playerClasses'],
          ),
        );
      }
    }

    return Future.wait(futures);
  }
}
