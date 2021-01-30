import 'package:dungeon_paper/src/atoms/markdown_help.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/lists/move_template_list.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:flutter/material.dart';

class CustomMoveFormBuilder extends StatefulWidget {
  final Move move;
  final DialogMode mode;
  final Widget Function(BuildContext context, Widget form, Function() onSave)
      builder;
  final void Function(Move move) onSave;
  final String moveLabel;

  CustomMoveFormBuilder({
    Key key,
    @required this.move,
    @required this.mode,
    @required this.builder,
    @required this.onSave,
    this.moveLabel = 'Move',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomMoveFormBuilderState();
}

class CustomMoveFormBuilderState extends State<CustomMoveFormBuilder> {
  Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    _controllers = WidgetUtils.textEditingControllerMap(map: {
      'name': widget.move.name ?? '',
      'description': widget.move.description ?? '',
      'explanation': widget.move.explanation ?? '',
    });
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
              labelText: '${widget.moveLabel} Name',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            autocorrect: true,
            textCapitalization: TextCapitalization.words,
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
              controller: _controllers['description'],
              // style: TextStyle(fontSize: 13.0),
              // textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Explanation',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              autofocus: widget.mode == DialogMode.edit,
              minLines: 6,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controllers['explanation'],
              // style: TextStyle(fontSize: 13.0),
              // textAlign: TextAlign.center,
            ),
          ),
          MoveTemplateList(onSelectTemplate: _insertTemplate),
          MarkdownHelp(),
        ],
      ),
    );

    return widget.builder(
      context,
      form,
      _updateMove,
    );
  }

  void _insertTemplate(String template) {
    final ctl = _controllers['description'];
    final sel = ctl.selection;

    // text is empty
    if ((sel.end == -1 && sel.start == -1) || ctl.text.isEmpty) {
      setState(() {
        ctl.text = template;
        ctl.selection =
            TextSelection(baseOffset: 0, extentOffset: template.length);
      });
      return;
    }

    // insert text on selection
    setState(() {
      ctl.text = ctl.text.substring(0, sel.start) +
          template +
          ctl.text.substring(sel.end);
      ctl.selection = TextSelection(
          baseOffset: sel.start, extentOffset: sel.start + template.length);
    });
  }

  void _updateMove() async {
    widget.onSave?.call(_move);
  }

  Move get _move => Move(
        key: widget.move.key,
        name: _controllers['name'].text,
        description: _controllers['description'].text,
        explanation: _controllers['explanation'].text,
        classes: [],
      );
}
