import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/models/converters/default_uuid.dart';
import 'package:dungeon_paper/db/models/converters/tag_converter.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'character.dart';

part 'note.freezed.dart';
part 'note.g.dart';

enum NoteKeys { key, title, description, category, tags }

@freezed
abstract class Note with KeyMixin implements _$Note {
  const Note._();

  const factory Note({
    @Default('Misc') String category,
    @required @DefaultUuid() String key,
    @required String title,
    @Default('') String description,
    @TagConverter() @Default([]) List<Tag> tags,
  }) = _Note;

  static final defaultCategories = [
    'NPCs',
    'Loot',
    'Locations',
    'Quests',
    'Misc'
  ];

  factory Note.fromJson(json) => _$NoteFromJson(json);
}

ReturnPredicate<Note> matchNote =
    matcher<Note>((Note i, Note o) => i.key == o.key);

Future<void> updateNote(Character character, Note note) => character
    .copyWith(notes: findAndReplaceInList<Note>(character.notes, note))
    .update(keys: ['notes']);

Future<void> deleteNote(Character character, Note note) => character
    .copyWith(notes: removeFromList(character.notes, note))
    .update(keys: ['notes']);

Future<void> createNote(Character character, Note note) => character
    .copyWith(notes: addToList(character.notes, note))
    .update(keys: ['notes']);

List<String> collectCategories(
  List<Note> notes, {
  bool includeDefault = true,
}) =>
    {
      if (includeDefault == true) ...Note.defaultCategories,
      ...groupByAlt<String, Note>(notes, (note) => note.category).keys
    }.toList();
