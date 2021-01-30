import 'package:dungeon_paper/db/models/note.dart';
import 'package:dungeon_paper/src/atoms/markdown_help.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/molecules/editable_tag_list.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class NoteFormBuilder extends StatefulWidget {
  final Note note;
  final List<String> categories;
  final DialogMode mode;
  final Widget Function(BuildContext context, Widget form, Function() onSave)
      builder;
  final void Function(Note note) onSave;

  NoteFormBuilder({
    Key key,
    @required this.note,
    @required this.mode,
    @required this.builder,
    @required this.categories,
    this.onSave,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteFormBuilderState();
}

class NoteFormBuilderState extends State<NoteFormBuilder> {
  Map<String, TextEditingController> _controllers;
  List<Tag> tags;

  @override
  void initState() {
    _controllers = {
      'category': TextEditingController(text: widget.note.category ?? ''),
      'title': TextEditingController(text: widget.note.title ?? ''),
      'description': TextEditingController(text: widget.note.description ?? ''),
    };
    tags = widget.note.tags ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget form = Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                labelText: 'Category',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              textCapitalization: TextCapitalization.words,
              controller: _controllers['category'],
            ),
            itemBuilder: (context, cat) => ListTile(
              title: Text(cat),
            ),
            suggestionsCallback: (search) => widget.categories.where(
              (cat) => cat.toLowerCase().contains(search.toLowerCase()),
            ),
            onSuggestionSelected: (cat) => _controllers['category'].text = cat,
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            autofocus: widget.mode == DialogMode.create,
            autocorrect: true,
            textCapitalization: TextCapitalization.words,
            controller: _controllers['title'],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              autofocus: widget.mode == DialogMode.edit,
              minLines: 6,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controllers['description'],
            ),
          ),
          EditableTagList(
            tags: tags,
            onSave: (t) => setState(() => tags = t),
          ),
          MarkdownHelp(),
        ],
      ),
    );

    return widget.builder(
      context,
      form,
      widget.mode == DialogMode.create ? _createNote : _updateNote,
    );
  }

  void _updateNote() async {
    var note = _generateNote();
    if (widget.onSave != null) {
      widget.onSave(note);
    }
    Get.back();
  }

  void _createNote() async {
    var note = _generateNote();
    if (widget.onSave != null) {
      widget.onSave(note);
    }
    Get.back();
  }

  Note _generateNote() => Note(
        key: widget.note.key,
        title: _controllers['title'].text,
        description: _controllers['description'].text,
        category: _controllers['category'].text,
        tags: [...tags],
      );
}
