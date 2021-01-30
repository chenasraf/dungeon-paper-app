import 'package:dungeon_paper/db/models/inventory_item.dart';
import 'package:dungeon_paper/src/atoms/markdown_help.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/molecules/editable_tag_list.dart';
import 'package:uuid/uuid.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:flutter/material.dart';

class InventoryItemForm extends StatefulWidget {
  final InventoryItem item;
  final DialogMode mode;
  final Widget Function(BuildContext context, Widget form, Function() onSave)
      builder;
  final void Function(InventoryItem move) onSave;

  InventoryItemForm({
    Key key,
    this.item,
    @required this.mode,
    @required this.builder,
    this.onSave,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => InventoryItemFormState();
}

class InventoryItemFormState extends State<InventoryItemForm> {
  Map<String, TextEditingController> _controllers;
  List<Tag> tags;

  @override
  void initState() {
    final item = widget.item ?? InventoryItem(key: Uuid().v4(), name: '');
    _controllers = WidgetUtils.textEditingControllerMap(map: {
      'name': EditingControllerConfig(defaultValue: item.name ?? ''),
      'description':
          EditingControllerConfig(defaultValue: item.description ?? ''),
      'amount':
          EditingControllerConfig(defaultValue: item.amount?.toString() ?? '1'),
    });
    tags = List.from(item.tags ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget form = Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                  controller: _controllers['name'],
                ),
              ),
              SizedBox(width: 12),
              Container(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Item Amount',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  keyboardType: TextInputType.number,
                  controller: _controllers['amount'],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              autofocus: widget.mode == DialogMode.edit,
              maxLines: null,
              minLines: 6,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,

              controller: _controllers['description'],
              // style: TextStyle(fontSize: 13.0),
              // textAlign: TextAlign.center,
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

    if (widget.builder != null) {
      return widget.builder(
        context,
        form,
        widget.mode == DialogMode.create ? _createItem : _updateItem,
      );
    }

    return form;
  }

  void _updateItem() => widget.onSave?.call(
        widget.item.copyWith(
          name: _controllers['name'].text,
          description: _controllers['description'].text,
          pluralName: _controllers['name'].text + 's',
          amount: int.tryParse(_controllers['amount'].text),
          tags: tags,
        ),
      );

  void _createItem() => widget.onSave?.call(
        InventoryItem(
          key: Uuid().v4(),
          name: _controllers['name'].text,
          description: _controllers['description'].text,
          tags: tags,
          pluralName: _controllers['name'].text + 's',
          amount: int.tryParse(_controllers['amount'].text) ?? 1,
        ),
      );
}
