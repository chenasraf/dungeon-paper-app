import 'package:dungeon_paper/db/models/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class NoteConverter implements JsonConverter<Note, Map<String, dynamic>> {
  const NoteConverter();

  @override
  Note fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Note.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Note data) => data.toJson();
}
