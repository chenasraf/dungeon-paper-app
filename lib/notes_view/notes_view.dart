import 'package:dungeon_paper/db/character.dart';
import 'package:dungeon_paper/db/notes.dart';
import 'package:dungeon_paper/main_view/main_view.dart';
import 'package:dungeon_paper/notes_view/note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesView extends StatelessWidget {
  final DbCharacter character;
  static const TextStyle titleStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  NotesView({Key key, this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> noteCategories = [];
    NoteCategory.defaultCategories.forEach((category) {
      Text title = Text(
        category.name,
        style: titleStyle,
        textAlign: TextAlign.left,
      );
      List<Widget> children = [title];
      for (num i = 0; i < character.notes.length; i++) {
        Note note = character.notes[i];
        if (note.category == category) {
          children.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child:
                NoteCard(key: Key('note-' + note.title), index: i, note: note),
          ));
        }
      }
      if (children.length > 1) {
        noteCategories.add(Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ));
      }
    });

    return OrientationBuilder(builder: (context, orientation) {
      return StaggeredGridView.countBuilder(
        crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
        itemCount: noteCategories.length + 1,
        itemBuilder: (context, index) => index < noteCategories.length
            ? noteCategories[index]
            : MainView.bottomSpacer,
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      );
    });
  }
}
