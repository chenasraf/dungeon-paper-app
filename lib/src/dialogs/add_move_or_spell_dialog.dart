import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMoveOrSpell extends StatelessWidget {
  final PlayerClass defaultClass;
  final Character character;

  const AddMoveOrSpell({
    Key key,
    this.defaultClass,
    @required this.character,
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
                  color: Color(0xFF9B1D20),
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: PlatformSvg.asset(
                      'swords.svg',
                      width: 30,
                      height: 30,
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                  ),
                  label: Text(
                    'Add Move',
                    style: Get.theme.textTheme.headline6.copyWith(
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.moveAdd);
                  },
                ),
              ),
              Container(height: 20),
              Container(
                height: 60,
                child: RaisedButton.icon(
                  color: Color(0xFF2274A5),
                  // icon: Icon(
                  //   Icons.book,
                  //   color: Get.theme.colorScheme.onSecondary,
                  //   size: 30,
                  // ),
                  icon: Icon(
                    Icons.menu_book_rounded,
                    color: Get.theme.colorScheme.onSecondary,
                    size: 30,
                  ),
                  // icon: Padding(
                  //   padding: const EdgeInsets.only(top: 8),
                  //   child: PlatformSvg.asset(
                  //     'book-stack.svg',
                  //     width: 30,
                  //     height: 30,
                  //     color: Get.theme.colorScheme.onSecondary,
                  //   ),
                  // ),
                  label: Text(
                    'Add Spell',
                    style: Get.theme.textTheme.headline6.copyWith(
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.spellAdd);
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
