import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/note.dart';
import 'package:dungeon_paper/src/atoms/flexible_columns.dart';
import 'package:dungeon_paper/src/atoms/empty_state.dart';
import 'package:dungeon_paper/src/atoms/search_bar.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/tag.dart';
import 'note_card.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  final Character character;

  NotesView({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  TextEditingController searchController;
  Iterable<Tag> selectedTags;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController()..addListener(_searchListener);
    selectedTags = [];
  }

  @override
  Widget build(BuildContext context) {
    if (cats.values.every((el) => el.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: EmptyState(
          title: Text('You have no notes'),
          subtitle: Text("Add notes for your campaign using the '+' button"),
          image: Icon(Icons.speaker_notes, size: 80),
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28),
          child: FlexibleColumns<String>.builder(
            keyBuilder: (ctx, key, idx) => 'NotesView.' + enumName(key),
            itemCount: (cat, idx) => filtered[cat].length,
            items: filtered.keys,
            bottomSpacerHeight: BOTTOM_SPACER.height,
            topSpacerHeight: 38,
            titleBuilder: (context, cat, idx) => Text(cat),
            itemBuilder: (context, cat, idx, catI) {
              final note = filtered[cat].elementAt(idx);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: NoteCard(
                  key: PageStorageKey(note.key),
                  note: note,
                  categories: collectCategories(widget.character.notes),
                  onSave: (_note) => updateNote(widget.character, _note),
                  onDelete: () => deleteNote(widget.character, note),
                ),
              );
            },
          ),
        ),
        // Column(
        //   children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBar(
            controller: searchController,
            hintText: 'Type to search notes',
          ),
        ),
        //     TagFilter(
        //       tags: allTags,
        //       selected: selectedTags,
        //       onChanged: (tags) => setState(
        //         () => selectedTags = tags,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Iterable<Tag> get allTags => cats.values.fold(
        <Tag>[],
        (previousValue, element) => unique([
          ...previousValue,
          ...element
              .map((e) => e.tags)
              .reduce((value, element) => [...value, ...element]),
        ], (t) => t.name),
      );

  Map<String, List<Note>> get cats =>
      groupBy<String, Note>(widget.character.notes, (note) => note.category);

  Map<String, List<Note>> get filtered => Map.from(
        cats.map(
          (key, value) => MapEntry(key, value.where(_isVisible).toList()),
        ),
      );

  void _searchListener() {
    setState(() {});
  }

  bool _isVisible(Note note) => [
        // text search
        searchController.text.isEmpty ||
            _matchStr(note.title) ||
            _matchStr(note.description) ||
            _matchStr(note.tags.map((t) => t.toJSON().toString()).join(', ')),
        // tag search
        selectedTags.isEmpty ||
            note.tags.any((tag) => selectedTags.contains(tag))
      ].every((element) => element == true);

  bool _matchStr(String str) => (str ?? '')
      .toLowerCase()
      .contains(searchController.text.toLowerCase().trim());
}
