import 'package:dungeon_paper/db/helpers/character_utils.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/dialogs/stat_dialog.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Character character;
  final CharacterStat stat;
  final void Function() onTap;

  const StatCard({
    Key key,
    @required this.character,
    @required this.stat,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = getValue(character, stat);

    return Expanded(
      child: Container(
        child: InkWell(
          onLongPress: _edit(context),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '${CHARACTER_STAT_LABELS[stat]}: $value',
                  style: TextStyle(fontSize: 11.0),
                ),
                Text(
                  '${CHARACTER_STAT_MODIFIER_LABELS[stat]} ' +
                      Character.statModifierText(value),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  num getValue(Character character, CharacterStat key) =>
      character.statValueFromKey(key);

  void Function() _edit(BuildContext context) {
    final value = getValue(character, stat);
    return () {
      showDialog(
        context: context,
        builder: (context) => StatDialog(
          stat: stat,
          value: value,
          character: character,
        ),
      );
    };
  }
}
