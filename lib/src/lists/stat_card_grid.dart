import 'package:dungeon_paper/db/helpers/character_utils.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/stat_card.dart';
import 'package:dungeon_paper/src/dialogs/roll_dice_view.dart';
import 'package:dungeon_paper/src/flutter_utils/dice_controller.dart';
import 'package:dungeon_paper/src/molecules/dice_roll_box.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BaseStats extends StatefulWidget {
  final Character character;

  const BaseStats({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  _BaseStatsState createState() => _BaseStatsState();
}

class _BaseStatsState extends State<BaseStats> {
  final GlobalKey globalKey = GlobalKey();
  final analyticsSource = 'Stat Card Grid';

  DiceListController diceController;
  String sessionKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StatCard(
                    character: widget.character,
                    stat: CharacterStat.str,
                    onTap: _roll(CharacterStat.str),
                  ),
                  StatCard(
                    character: widget.character,
                    stat: CharacterStat.dex,
                    onTap: _roll(CharacterStat.dex),
                  ),
                  StatCard(
                    character: widget.character,
                    stat: CharacterStat.con,
                    onTap: _roll(CharacterStat.con),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StatCard(
                    character: widget.character,
                    stat: CharacterStat.int,
                    onTap: _roll(CharacterStat.int),
                  ),
                  StatCard(
                    character: widget.character,
                    stat: CharacterStat.wis,
                    onTap: _roll(CharacterStat.wis),
                  ),
                  StatCard(
                    character: widget.character,
                    stat: CharacterStat.cha,
                    onTap: _roll(CharacterStat.cha),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (sessionKey != null && diceController != null)
          Padding(
            key: globalKey,
            padding: const EdgeInsets.only(top: 16),
            child: DiceRollBox(
              analyticsSource: analyticsSource,
              key: Key(sessionKey),
              controller: diceController,
              onEdit: () => _openRoll(diceController.value),
              onRemove: _unroll,
            ),
          )
      ],
    );
  }

  String generateSessionKey() => Uuid().v4();

  void Function() _roll(CharacterStat key) {
    return () {
      setState(() {
        sessionKey = generateSessionKey();
        final list = [Dice(6, 2, widget.character.modifierFromKey(key))];
        diceController = DiceListController(list);
        Future.delayed(
          Duration(milliseconds: 50),
          () => Scrollable.ensureVisible(globalKey.currentContext,
              duration: Duration(milliseconds: 200)),
        );
      });
    };
  }

  void _unroll() {
    setState(() {
      diceController = null;
      sessionKey = null;
    });
  }

  void _openRoll(List<Dice> dice) {
    final _dice = [...dice];
    showDiceRollView(
      analyticsSource: analyticsSource,
      character: widget.character,
      initialAddingDice: _dice,
    );
  }
}
