import 'package:dungeon_paper/components/dialogs.dart';
import 'package:dungeon_paper/db/spells.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

import 'add_move_screen.dart';
import 'add_spell_screen.dart';

class AddMoveOrSpell extends StatelessWidget {
  const AddMoveOrSpell({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // title: Text('Add Move/Spell'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          // .copyWith(bottom: 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 60,
                child: RaisedButton.icon(
                  color: Colors.orange,
                  icon: SvgPicture.asset(
                    'assets/swords.svg',
                    width: 24,
                    height: 24,
                  ),
                  label: Text(
                    'Add Move',
                    style: Theme.of(context).textTheme.title,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (ctx) => AddMoveScreen(
                          move: Move(
                            key: Uuid().v4(),
                            name: '',
                            description: '',
                            classes: [],
                            explanation: '',
                          ),
                          mode: DialogMode.Create,
                          index: -1,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(height: 20),
              Container(
                height: 60,
                child: RaisedButton.icon(
                  color: Colors.lightBlue,
                  icon: Icon(Icons.book),
                  label: Text(
                    'Add Spell',
                    style: Theme.of(context).textTheme.title,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (ctx) => AddSpellScreen(
                          spell: DbSpell(
                            key: Uuid().v4(),
                            name: '',
                            description: '',
                            tags: [],
                            level: '1-5',
                          ),
                          mode: DialogMode.Create,
                          index: -1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}