import 'package:dungeon_paper/db/character.dart';
import 'package:dungeon_paper/db/character_types.dart';
import 'package:dungeon_paper/profile_view/edit_stat_dialog.dart';
import 'package:dungeon_paper/redux/stores/connectors.dart';
import 'package:flutter/material.dart';

class BaseStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DWStoreConnector(builder: (context, state) {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StatCard(name: 'str'),
                StatCard(name: 'dex'),
                StatCard(name: 'con'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StatCard(name: 'int'),
                StatCard(name: 'wis'),
                StatCard(name: 'cha'),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class StatCard extends StatelessWidget {
  StatCard({
    Key key,
    @required this.name,
  })  : fullName = StatNameMap[name],
        super(key: key);

  final String name;
  final String fullName;

  @override
  Widget build(BuildContext _context) {
    return DWStoreConnector(builder: (context, state) {
      DbCharacter character = state.characters.current;
      num value = character[name.toLowerCase()];

      return Expanded(
        child: Card(
          margin: EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () => showDialog(
                  context: context,
                  builder: (context) => EditStatDialog(name: name, value: value),
                ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('$fullName: $value', style: TextStyle(fontSize: 11.0)),
                  Text(
                    '${name.toUpperCase()} ' +
                    DbCharacter.statModifierText(value),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
