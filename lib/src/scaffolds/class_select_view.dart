import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/lists/player_class_list.dart';
import 'package:dungeon_paper/src/organisms/class_description.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassSelectView extends StatelessWidget {
  final Character character;
  final DialogMode mode;
  final VoidCallbackDelegate<Character> onUpdate;

  const ClassSelectView({
    Key key,
    @required this.character,
    @required this.onUpdate,
    this.mode = DialogMode.edit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PlayerClassList(
          builder: (context, list) {
            var sorted = [...list]
              ..sort((a, b) => character.mainClass == a ? -1 : 1);
            return Column(
              children: [
                for (var availClass in sorted)
                  CardListItem(
                    title: Text(availClass.name),
                    subtitle: Text('Preview class'),
                    leading: Icon(Icons.person, size: 40.0),
                    color: Get.theme.canvasColor.withOpacity(
                        availClass == character.mainClass ? 1 : 0.7),
                    trailing: Icon(Icons.chevron_right),
                    onTap: previewClass(context, availClass),
                  ),
              ],
            );
          },
        ),
      ),
    );
    return child;
  }

  void chooseClass(BuildContext context, PlayerClass def) async {
    if (mode == DialogMode.create) {
      save(context, def, ChangeClassConfirmationOptions.all(true));
      Get.back(result: true);
      return;
    }
    var options = await showDialog<ChangeClassConfirmationOptions>(
      context: context,
      builder: (context) => ConfirmClassChangeDialog(mode: mode),
    );
    if (options != null) {
      save(context, def, options);
      Get.back(result: true);
    }
  }

  void save(BuildContext context, PlayerClass def,
      ChangeClassConfirmationOptions options) {
    var result = options.applyToCharacter(character, def);
    onUpdate?.call(result.character.copyWith(playerClasses: [def]));
  }

  Function() previewClass(BuildContext context, PlayerClass def) {
    return () async {
      try {
        var res = await Get.to(
          ClassPreview(
            classDef: def,
            onSave: () => chooseClass(context, def),
          ),
        );
        if (res == true && mode == DialogMode.edit) {
          Get.back(result: res);
        }
      } catch (e) {
        logger.e(e);
        Get.back(result: false);
      }
    };
  }
}

class ClassPreview extends StatelessWidget {
  final PlayerClass classDef;
  final void Function() onSave;

  const ClassPreview({
    Key key,
    @required this.classDef,
    @required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cls = classDef;
    return MainScaffold(
      title: Text(cls.name),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text('Choose'),
            color: Get.theme.canvasColor,
            onPressed: onSave,
          ),
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClassDescription(classDef: cls),
        ),
      ),
    );
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
    var isEdit = widget.mode == DialogMode.edit;
    return ConfirmationDialog(
        title: Text(isEdit ? 'Change Class?' : 'Choose Class?'),
        okButtonText:
            Text(isEdit ? "I'm sure, let's do this" : 'Choose this class'),
        cancelButtonText: Text('Wait, not yet'),
        returnValue: (confirmed) {
          return confirmed
              ? isEdit
                  ? options
                  : ChangeClassConfirmationOptions.all(true)
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

  ChangeClassConfirmationResults({
    @required this.character,
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
    if (deleteMoves) {
      character = character.copyWith(moves: []);
    }

    if (resetXP) {
      character = character.copyWith(
        level: 1,
        currentXP: 0,
      );
    }

    if (resetMaxHP) {
      character = character.copyWith(
        customMaxHP: character.defaultMaxHP,
        customCurrentHP: character.maxHP,
      );
    }

    if (resetHitDice) {
      character = character.copyWith(customDamageDice: mainClass.damage);
    }

    return ChangeClassConfirmationResults(character: character);
  }
}
