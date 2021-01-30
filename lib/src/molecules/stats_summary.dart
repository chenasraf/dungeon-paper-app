import 'package:dungeon_paper/db/helpers/character_utils.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsSummary extends StatelessWidget {
  final Character character;

  const StatsSummary({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rows = <List<CharacterStat>>[
      ORDERED_STATS.sublist(0, 3),
      ORDERED_STATS.sublist(3)
    ];
    var round = Radius.circular(4);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        for (var row in rows)
          Row(
            children: <Widget>[
              for (var stat in row)
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 0,
                    color: Get.theme.canvasColor.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 22.0),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.bodyText2,
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${CHARACTER_STAT_LABELS[stat]}: ${_getStat(stat)}',
                              style: TextStyle(fontSize: 11.0),
                            ),
                            Text(
                              '${CHARACTER_STAT_MODIFIER_LABELS[stat]} ' +
                                  Character.statModifierText(_getStat(stat)),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft:
                            rows[0].indexOf(stat) == 0 ? round : Radius.zero,
                        topRight:
                            rows[0].indexOf(stat) == 2 ? round : Radius.zero,
                        bottomRight:
                            rows[1].indexOf(stat) == 2 ? round : Radius.zero,
                        bottomLeft:
                            rows[1].indexOf(stat) == 0 ? round : Radius.zero,
                      ),
                    ),
                  ),
                ),
            ],
          )
      ],
    );
  }

  int _getStat(CharacterStat stat) => character.statValueFromKey(stat);
}
