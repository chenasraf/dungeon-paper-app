import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/organisms/class_description.dart';
import 'package:dungeon_paper/src/pages/character_wizard/character_wizard_utils.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';

class ClassSelectionScaffold extends StatelessWidget {
  final Character character;
  final DialogMode mode;
  final CharSaveFunction onSave;
  final ScaffoldBuilderFunction builder;

  const ClassSelectionScaffold({
    Key key,
    @required this.character,
    @required this.onSave,
    this.builder,
    this.mode = DialogMode.Edit,
  }) : super(key: key);

  ClassSelectionScaffold.withScaffold({
    Key key,
    @required this.character,
    @required this.onSave,
    this.mode = DialogMode.Edit,
    Function() onDidPop,
    Function() onWillPop,
  })  : builder = characterWizardScaffold(
          mode: mode,
          titleText: 'Main Class',
          buttonType: WizardScaffoldButtonType.back,
          onDidPop: onDidPop,
          onWillPop: onWillPop,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: dungeonWorld.classes
            .map(
              (availClass) => Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: CardListItem(
                  title: Text(availClass.name),
                  subtitle: Text('Preview class'),
                  leading: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.person, size: 40.0),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: previewClass(context, availClass),
                ),
              ),
            )
            .toList(),
      ),
    );
    if (builder != null) {
      return builder(context: context, child: child, save: null, isValid: null);
    }
    return child;
  }

  void chooseClass(BuildContext context, PlayerClass def) async {
    if (mode == DialogMode.Create) {
      save(context, def, ChangeClassConfirmationOptions.all(true));
      Navigator.pop(context, true);
      return;
    }
    ChangeClassConfirmationOptions options = await showDialog(
      context: context,
      builder: (context) => ConfirmClassChangeDialog(mode: mode),
    );
    if (options != null) {
      save(context, def, options);
      Navigator.pop(context, true);
    }
  }

  void save(BuildContext context, PlayerClass def,
      ChangeClassConfirmationOptions options) {
    var result = options.applyToCharacter(character, def);
    character.mainClass = def;
    onSave(
      result.data
        ..addAll(
          {
            'playerClasses': [def.toJSON()],
            'looks': [],
            'race': null,
          },
        ),
    );
  }

  Function() previewClass(BuildContext context, PlayerClass def) {
    return () async {
      try {
        bool res = await Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => ClassPreview(
              classDef: def,
              onSave: () => chooseClass(context, def),
            ),
          ),
        );
        if (res == true && mode == DialogMode.Edit) {
          Navigator.pop(context, res);
        }
      } catch (e) {
        print(e);
        Navigator.pop(context, false);
      }
    };
  }
}

class ClassPreview extends StatefulWidget {
  final PlayerClass classDef;
  final void Function() onSave;

  const ClassPreview({
    Key key,
    @required this.classDef,
    @required this.onSave,
  }) : super(key: key);

  @override
  _ClassPreviewState createState() => _ClassPreviewState();
}

class _ClassPreviewState extends State<ClassPreview> {
  ScrollController scrollController = ScrollController();
  double appBarElevation = 0.0;

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cls = widget.classDef;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(cls.name),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Choose'),
              color: Theme.of(context).canvasColor,
              onPressed: widget.onSave,
            ),
          )
        ],
        elevation: appBarElevation,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClassDescription(classDef: cls),
      )),
    );
  }

  void scrollListener() {
    double newElevation = scrollController.offset > 16.0 ? 1.0 : 0.0;
    if (newElevation != appBarElevation) {
      setState(() {
        appBarElevation = newElevation;
      });
    }
  }
}

class ConfirmClassChangeDialog extends StatefulWidget {
  final DialogMode mode;

  const ConfirmClassChangeDialog({
    Key key,
    @required this.mode,
  }) : super(key: key);

  @override
  _ConfirmClassChangeDialogState createState() =>
      _ConfirmClassChangeDialogState();
}

class _ConfirmClassChangeDialogState extends State<ConfirmClassChangeDialog> {
  ChangeClassConfirmationOptions options;

  @override
  void initState() {
    options = ChangeClassConfirmationOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.mode == DialogMode.Edit;
    return ConfirmationDialog(
        title: Text(isEdit ? 'Change Class?' : 'Choose Class?'),
        okButtonText:
            Text(isEdit ? "I'm sure, let's do this" : 'Choose this class'),
        cancelButtonText: Text('Wait, not yet'),
        returnValue: (bool confirmed) {
          return confirmed
              ? isEdit ? options : ChangeClassConfirmationOptions.all(true)
              : null;
        },
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(bottom: 40.0),
              child: Text(isEdit
                  ? 'Please confirm your selection.\n\nPlease note: race and looks will automatically reset.'
                  : 'If this is the main class of your choosing, tap "Choose this class".'),
            ),
            if (isEdit) ...[
              checkboxRow(
                'Remove all previous moves from current class',
                options.deleteMoves,
                toggleDeleteMoves,
              ),
              checkboxRow(
                'Set level to 1 and XP to 0',
                options.resetXP,
                toggleResetXP,
              ),
              checkboxRow(
                'Reset Max HP to match this class',
                options.resetMaxHP,
                toggleResetMaxHP,
              ),
              checkboxRow(
                'Update damage dice to match this class',
                options.resetHitDice,
                toggleUpdateHitDice,
              ),
            ]
          ],
        ));
  }

  Widget checkboxRow(String text, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: value ?? false,
          onChanged: onChanged,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(text),
          ),
        ),
      ],
    );
  }

  void toggleDeleteMoves(bool state) {
    setState(() {
      options.deleteMoves = state;
    });
  }

  void toggleResetXP(bool state) {
    setState(() {
      options.resetXP = state;
    });
  }

  void toggleResetMaxHP(bool state) {
    setState(() {
      options.resetMaxHP = state;
    });
  }

  void toggleUpdateHitDice(bool state) {
    setState(() {
      options.resetHitDice = state;
    });
  }
}

class ChangeClassConfirmationResults {
  final Character character;
  final Map<String, dynamic> data;

  ChangeClassConfirmationResults({
    @required this.character,
    @required this.data,
  });
}

class ChangeClassConfirmationOptions {
  bool deleteMoves;
  bool resetXP;
  bool resetMaxHP;
  bool resetHitDice;

  ChangeClassConfirmationOptions({
    this.deleteMoves = false,
    this.resetXP = false,
    this.resetMaxHP = false,
    this.resetHitDice = false,
  });

  factory ChangeClassConfirmationOptions.all(bool val) =>
      ChangeClassConfirmationOptions(
        deleteMoves: val,
        resetXP: val,
        resetMaxHP: val,
        resetHitDice: val,
      );

  ChangeClassConfirmationResults applyToCharacter(
      Character character, PlayerClass mainClass) {
    var data = <String, dynamic>{};

    if (deleteMoves) {
      data['moves'] = [];
    }

    if (resetXP) {
      data['level'] = 1;
      data['currentXP'] = 0;
    }

    if (resetMaxHP) {
      data['maxHP'] = character.defaultMaxHP;
      data['currentHP'] = character.maxHP;
    }

    if (resetHitDice) {
      data['hitDice'] = mainClass.damage;
    }

    return ChangeClassConfirmationResults(character: character, data: data);
  }
}
