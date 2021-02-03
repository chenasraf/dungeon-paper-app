import 'package:dungeon_paper/db/helpers/character_utils.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/atoms/number_controller.dart';
import 'package:dungeon_paper/src/atoms/roll_button_with_edit.dart';
import 'package:dungeon_paper/src/dialogs/roll_dice_view.dart';
import 'package:dungeon_paper/src/dialogs/standard_dialog_controls.dart';
import 'package:dungeon_paper/src/flutter_utils/dice_controller.dart';
import 'package:dungeon_paper/src/molecules/dice_roll_box.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';

class StatDialog extends StatefulWidget {
  final CharacterStat stat;
  final num value;
  final Character character;

  StatDialog({
    Key key,
    @required this.stat,
    @required this.value,
    @required this.character,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      StatDialogState(stat: stat, value: value);
}

class StatDialogState extends State<StatDialog> {
  final CharacterStat stat;
  final String fullName;
  final analyticsSource = Routes.statEdit.analyticsName;

  num value;
  bool valueError = false;
  bool saving = false;
  DiceListController rollingController;
  String rollSession;

  StatDialogState({
    Key key,
    @required this.stat,
    @required this.value,
  })  : fullName = CHARACTER_STAT_LABELS[stat],
        super();

  @override
  Widget build(BuildContext context) {
    var modifier = Character.statModifierText(value);
    var name = enumName(stat);
    var statName = name.toUpperCase();

    return AlertDialog(
      title: Text('Edit $fullName'),
      contentPadding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('$fullName: $value'),
            Text(
              '${statName}: $modifier',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: 240,
              child: NumberController(
                min: 1,
                max: MAX_STAT_VALUE,
                value: value,
                onChange: _setStateValue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: RollButtonWithEdit(
                label: Text('Roll 2d6 + $statName'),
                diceList: dice,
                onRoll: _rollStat,
                character: widget.character,
                analyticsSource: analyticsSource,
                brightness: Brightness.light,
              ),
            ),
            if (rollingController != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0)
                    .copyWith(bottom: 8),
                child: DiceRollBox(
                  analyticsSource: analyticsSource,
                  key: Key(rollSession),
                  controller: rollingController,
                  onRemove: _removeRoll,
                  onEdit: _editRoll,
                ),
              ),
          ],
        ),
      ),
      actions: StandardDialogControls.actions(
        context: context,
        onConfirm: saving ? null : _saveValue,
        confirmDisabled: valueError,
        onCancel: () => Get.back(),
      ),
    );
  }

  void _setStateValue(num newValue) {
    setState(() {
      if (newValue == null) {
        valueError = true;
      } else {
        valueError = false;
        value = newValue;
      }
    });
  }

  void _saveValue() async {
    var character = characterController.current.copyWithStat(stat, value);
    setState(() {
      saving = true;
    });
    unawaited(character.update(keys: [Character.getStatUpdateKey(stat)]));
    unawaited(analytics.logEvent(name: Events.EditStat));
    Get.back();
  }

  void _removeRoll() {
    setState(() {
      rollingController = null;
      rollSession = null;
    });
  }

  void _editRoll() {
    showDiceRollView(
      character: widget.character,
      initialAddingDice: rollingController.value,
      analyticsSource: analyticsSource,
    );
  }

  void _rollStat() {
    setState(() {
      rollingController = DiceListController(dice);
      rollSession = Uuid().v4();
    });
  }

  List<Dice> get dice => [Dice(6, 2, Character.modifierFromValue(value))];
}
