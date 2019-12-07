import 'package:dungeon_paper/utils.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../components/title_subtitle_row.dart';
import '../../db/character.dart';
import '../../db/character_utils.dart';
import '../../components/dialogs.dart';
import 'character_wizard_utils.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';

class ChangeLooksDialog extends StatefulWidget {
  final DbCharacter character;
  final DialogMode mode;
  final CharSaveFunction onSave;
  final ScaffoldBuilderFunction builder;

  const ChangeLooksDialog({
    Key key,
    @required this.character,
    @required this.onSave,
    this.mode = DialogMode.Edit,
    this.builder,
  }) : super(key: key);

  ChangeLooksDialog.withScaffold({
    Key key,
    @required this.character,
    @required this.onSave,
    this.mode = DialogMode.Edit,
    Function() onDidPop,
    Function() onWillPop,
  })  : builder = characterWizardScaffold(
          mode: mode,
          titleText: 'Edit Looks',
          onDidPop: onDidPop,
          onWillPop: onWillPop,
          buttonType: WizardScaffoldButtonType.back,
        ),
        super(key: key);

  @override
  _ChangeLooksDialogState createState() => _ChangeLooksDialogState();
}

class _ChangeLooksDialogState extends State<ChangeLooksDialog> {
  List<String> selected;
  List<TextEditingController> _controllers;
  List<List<String>> looksOptions;

  @override
  void initState() {
    looksOptions = widget.character.mainClass.looks;
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
                            hintText: looksOptions[i % looksOptions.length]
                                    .take(3)
                                    .join(', ') +
                                '...',
                          ),
                          controller: _controllers[i],
                          textCapitalization: TextCapitalization.words,
                        ),
                        suggestionsCallback: (term) async => term.isNotEmpty
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
                    backgroundColor: Theme.of(context).canvasColor,
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

    if (widget.builder != null) {
      return widget.builder(
        context: context,
        child: child,
        save: _save,
        isValid: _isValid,
        wrapWithScrollable: false,
      );
    }
    return child;
  }

  void changeLooks(List<String> def) async {
    widget.character.looks = def;
    widget.onSave(widget.character, [CharacterKeys.looks]);
  }

  void _setValue(int i, String val) {
    setState(() {
      selected[i] = val;
      _controllers[i].text = val;
    });
    print(selected);
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

  bool _isValid() {
    return true;
    // return selected.length == widget.character.mainClass.looks.length &&
    //     selected.every((s) => s != null && s.isNotEmpty);
  }

  void _save() {
    List<String> filtered =
        selected.where((s) => s != null && s.isNotEmpty).toList();
    changeLooks(filtered);
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
    return TitleSubtitleCard(
      color: color ??
          Theme.of(context)
              .canvasColor
              .withOpacity(playerClass.looks.isNotEmpty ? 1.0 : 0.85),
      elevation: elevation,
      margin: margin,
      title: Text('Looks'),
      leading: Icon(Icons.person_pin, size: 40),
      subtitle:
          Text(looks.isNotEmpty ? looks.join('; ') : 'No features selected'),
      trailing: onTap != null ? Icon(Icons.chevron_right) : null,
      onTap: playerClass.looks.isNotEmpty ? onTap : null,
    );
  }
}
