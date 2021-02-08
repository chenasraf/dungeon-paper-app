import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LooksView extends StatefulWidget {
  final Character character;
  final DialogMode mode;
  final VoidCallbackDelegate<Character> onUpdate;

  const LooksView({
    Key key,
    @required this.character,
    @required this.onUpdate,
    this.mode = DialogMode.edit,
  }) : super(key: key);

  @override
  _LooksViewState createState() => _LooksViewState();
}

class _LooksViewState extends State<LooksView> {
  List<String> selected;
  List<TextEditingController> _controllers;
  List<List<String>> looksOptions;

  @override
  void initState() {
    looksOptions = widget.character.playerClass.looks;
    selected = List.generate(
        widget.character.looks.isNotEmpty
            ? widget.character.looks.length
            : looksOptions.length,
        (i) => widget.character.looks.isNotEmpty &&
                widget.character.looks.length >= i
            ? widget.character.looks[i]
            : null);
    _controllers = List.generate(
      widget.character.looks.isNotEmpty
          ? widget.character.looks.length
          : looksOptions.length,
      (i) => TextEditingController(
        text: selected[i] ?? '',
      )..addListener(() {
          setState(() {
            selected[i] = _controllers[i].text;
            changeLooks(selected);
          });
        }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (var i = 0; i < selected.length; i++)
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Enter a small feature of your appearance.'),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removeRow(i);
                              }),
                        ],
                      ),
                      TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                            hintText: looksOptions.isNotEmpty
                                ? looksOptions[i % looksOptions.length]
                                        .take(3)
                                        .join(', ') +
                                    '...'
                                : "Describe a feature of your character's appearance",
                          ),
                          controller: _controllers[i],
                          textCapitalization: TextCapitalization.words,
                        ),
                        suggestionsCallback: (term) async => term.isNotEmpty &&
                                looksOptions.isNotEmpty
                            ? (looksOptions.length > i
                                    ? looksOptions[i]
                                    : looksOptions
                                        .reduce((all, cur) => [...all, ...cur]))
                                .where(
                                  (val) => val.toLowerCase().contains(
                                        term.trim().toLowerCase(),
                                      ),
                                )
                                .map(capitalize)
                                .toList()
                            : [],
                        itemBuilder: (context, val) {
                          return ListTile(title: Text(val));
                        },
                        noItemsFoundBuilder: (context) =>
                            Container(width: 0, height: 0),
                        onSuggestionSelected: (val) => _setValue(i, val),
                      ),
                    ],
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    backgroundColor: Get.theme.canvasColor,
                    foregroundColor: Get.theme.colorScheme.onSurface,
                    child: Icon(Icons.add),
                    onPressed: _addRow,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    return child;
  }

  void changeLooks(List<String> def) async {
    var char = widget.character.copyWith(looks: def);
    widget.onUpdate?.call(char);
  }

  void _setValue(int i, String val) {
    setState(() {
      selected[i] = val;
      _controllers[i].text = val;
    });
  }

  void _addRow() {
    setState(() {
      num i = selected.length;
      selected.add('');
      _controllers.add(
        TextEditingController(text: '')
          ..addListener(() {
            setState(() {
              selected[i] = _controllers[i].text;
            });
          }),
      );
    });
  }

  void _removeRow(num i) {
    setState(() {
      selected.removeAt(i);
      _controllers.removeAt(i);
    });
  }
}

class LooksDescription extends StatelessWidget {
  final void Function() onTap;
  final PlayerClass playerClass;
  final List<String> looks;
  final Color color;
  final double elevation;
  final EdgeInsets margin;

  const LooksDescription({
    Key key,
    this.onTap,
    @required this.playerClass,
    @required this.looks,
    this.color,
    this.elevation,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardListItem(
      color: color ?? Get.theme.canvasColor,
      elevation: elevation,
      margin: margin,
      title: Text('Looks'),
      leading: Icon(Icons.person_pin, size: 40),
      subtitle:
          Text(looks.isNotEmpty ? looks.join('; ') : 'No features selected'),
      trailing: onTap != null ? Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}
