import 'package:dungeon_paper/db/models/spell.dart';
import 'package:dungeon_paper/src/atoms/markdown_help.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/molecules/editable_tag_list.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:flutter/material.dart';

class CustomSpellFormBuilder extends StatefulWidget {
  final DbSpell spell;
  final DialogMode mode;
  final Widget Function(BuildContext context, Widget form, Function() onSave)
      builder;
  final void Function(DbSpell move) onSave;

  CustomSpellFormBuilder({
    Key key,
    @required this.spell,
    @required this.mode,
    @required this.builder,
    @required this.onSave,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomSpellFormBuilderState();
}

class CustomSpellFormBuilderState extends State<CustomSpellFormBuilder> {
  String name;
  String description;
  String explanation;
  Map<String, TextEditingController> _controllers;
  List<Tag> tags;

  @override
  void initState() {
    _controllers = {
      'name': TextEditingController(text: (widget.spell.name ?? '').toString()),
      'description': TextEditingController(
          text: (widget.spell.description ?? '').toString()),
    };
    name = _controllers['name'].text;
    description = _controllers['description'].text;
    tags = widget.spell.tags.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget form = Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Spell Name',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            autocorrect: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (val) => _setStateValue('name', val),
            controller: _controllers['name'],
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
              onChanged: (val) => _setStateValue('description', val),
              controller: _controllers['description'],
            ),
          ),
          EditableTagList(
            tags: tags,
            onSave: (updated) => setState(() {
              tags = updated;
            }),
          ),
          MarkdownHelp(),
        ],
      ),
    );

    return widget.builder(context, form, _saveSpell);
  }

  void _setStateValue(String key, String newValue) {
    setState(() {
      switch (key) {
        case 'name':
          name = newValue;
          return;
        case 'description':
          description = newValue;
          return;
        case 'explanation':
          explanation = newValue;
          return;
      }
    });
  }

  void _saveSpell() async {
    var spell = _generateSpell();
    if (widget.onSave != null) {
      widget.onSave(spell);
    }
  }

  DbSpell _generateSpell() {
    return DbSpell(
      key: widget.spell.key,
      name: name,
      description: description,
      level: widget.spell.level,
      prepared: widget.spell.prepared,
      tags: tags,
    );
  }
}
