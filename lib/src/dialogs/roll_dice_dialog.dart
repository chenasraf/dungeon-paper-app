import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/flutter_utils/dice_controller.dart';
import 'package:dungeon_paper/src/molecules/dice_roll_box.dart';
import 'package:dungeon_paper/src/molecules/dice_roll_builder.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:flutter/material.dart';

class RollDiceDialog extends StatefulWidget {
  final Character character;

  const RollDiceDialog({
    Key key,
    this.character,
  }) : super(key: key);

  @override
  _RollDiceDialogState createState() => _RollDiceDialogState();
}

class _RollDiceDialogState extends State<RollDiceDialog> {
  List<List<Dice>> diceList;
  List<DiceListController> controllers;

  @override
  void initState() {
    diceList = [];
    controllers = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52,
          child: Center(
            child: Text(
              'Roll Dice',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Theme.of(context).canvasColor,
                  ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var list in enumerate(controllers))
                  Padding(
                    padding: list.index > 0
                        ? const EdgeInsets.symmetric(vertical: 16)
                        : EdgeInsets.only(bottom: 16),
                    child: DiceRollBox(
                      key: Key('dice-${list.value.hash}'),
                      diceList: list.value.value,
                      controller: controllers[list.index],
                      onRemove: () => _removeAt(list.index),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DiceRollBuilder(
                    character: widget.character,
                    onChanged: _add,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _add(List<Dice> dice) {
    setState(() {
      var _ctrl = DiceListController([...dice]);
      controllers.add(_ctrl);
      diceList.add(dice);
    });
  }

  void _removeAt(num idx) {
    setState(() {
      diceList.removeAt(idx);
      controllers.removeAt(idx);
    });
  }
}
