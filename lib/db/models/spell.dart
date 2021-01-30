import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/models/converters/default_uuid.dart';
import 'package:dungeon_paper/db/models/converters/tag_converter.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/spell.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'character.dart';

part 'spell.freezed.dart';
part 'spell.g.dart';

ReturnPredicate<DbSpell> matchSpell =
    matcher<DbSpell>((DbSpell i, DbSpell o) => i.key == o.key);

@freezed
abstract class DbSpell with KeyMixin implements _$DbSpell {
  const DbSpell._();

  const factory DbSpell({
    @required @DefaultUuid() String key,
    @required String name,
    @Default('') String description,
    @required String level,
    @Default([]) @TagConverter() List<Tag> tags,
    @Default(false) bool prepared,
  }) = _DbSpell;

  static DbSpell fromSpell(Spell spell, {bool prepared = false}) => DbSpell(
        key: spell.key,
        name: spell.name,
        description: spell.description,
        level: spell.level,
        tags: spell.tags,
        prepared: prepared,
      );

  factory DbSpell.fromJson(Map json) => _$DbSpellFromJson(json);
}

Future<void> updateSpell(Character character, DbSpell spell) => character
    .copyWith(spells: findAndReplaceInList(character.spells, spell))
    .update(keys: ['spells']);

Future<void> deleteSpell(Character character, DbSpell spell) => character
    .copyWith(spells: removeFromList(character.spells, spell))
    .update(keys: ['spells']);

Future<void> createSpell(Character character, DbSpell spell) => character
    .copyWith(spells: addToList(character.spells, spell))
    .update(keys: ['spells']);
