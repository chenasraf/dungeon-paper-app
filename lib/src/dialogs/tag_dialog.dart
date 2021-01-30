import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/tag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dialogs.dart';
import 'standard_dialog_controls.dart';

class TagDialog extends StatefulWidget {
  final Tag tag;
  final Function(Tag tag) onSave;

  const TagDialog({Key key, this.onSave, this.tag}) : super(key: key);

  @override
  _TagDialogState createState() => _TagDialogState();
}

enum TagValueTypes { number, text, bool }

class _TagDialogState extends State<TagDialog> {
  Map<String, TextEditingController> _controllers;
  DialogMode _mode;
  List<Tag> _copyableTags;

  @override
  void initState() {
    _controllers = {
      'name': TextEditingController.fromValue(
        TextEditingValue(text: widget.tag?.name ?? ''),
      ),
      'description': TextEditingController.fromValue(
        TextEditingValue(text: (widget.tag?.description ?? '').toString()),
      ),
      'value': TextEditingController.fromValue(
        TextEditingValue(text: (widget.tag?.value ?? '').toString()),
      ),
    };
    _copyableTags = dungeonWorld.tags..sort((a, b) => a.name.compareTo(b.name));
    _mode = widget.tag != null ? DialogMode.edit : DialogMode.create;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text((_mode == DialogMode.edit ? 'Edit' : 'Create') + ' Tag'),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Presets:'),
                SizedBox(width: 24),
                Expanded(
                  child: DropdownButtonFormField<Tag>(
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('None'),
                      ),
                      for (Tag copyableTag in _copyableTags)
                        DropdownMenuItem(
                          value: copyableTag,
                          child: Text(capitalize(copyableTag.toString())),
                        )
                    ],
                    onChanged: copyTag,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Tag name'),
              controller: _controllers['name'],
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: null,
              decoration: InputDecoration(labelText: 'Tag description'),
              controller: _controllers['description'],
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Tag value'),
              controller: _controllers['value'],
            ),
          ],
        ),
      ),
      actions: StandardDialogControls.actions(
        context: context,
        onConfirm: onSave,
      ),
    );
  }

  void onSave() {
    Get.back();
    widget.onSave(tag);
  }

  void copyTag(Tag tagToCopy) {
    if (tagToCopy == null) return;
    setState(() {
      _controllers['name'].text = tagToCopy.name ?? '';
      _controllers['value'].text = (tagToCopy.value ?? '').toString();
      _controllers['description'].text = tagToCopy.description ?? '';
    });
  }

  Tag get tag {
    var name = _controllers['name'].text;
    var value = _controllers['value'].text;
    var description = _controllers['description'].text;

    dynamic parsedValue = value.toString();
    if (RegExp(r'^\d+\.\d+$').hasMatch(value)) {
      parsedValue = double.tryParse(value);
    } else if (RegExp(r'^\d+$').hasMatch(value)) {
      parsedValue = int.tryParse(value);
    } else if (value == 'true') {
      parsedValue = true;
    } else if (value == 'false') parsedValue = false;
    if (parsedValue == '') parsedValue = null;
    return Tag(name, parsedValue, description);
  }
}
