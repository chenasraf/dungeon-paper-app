import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/dice_icon.dart';
import 'package:dungeon_paper/src/dialogs/armor_dialog.dart';
import 'package:dungeon_paper/src/dialogs/damage_dice_dialog.dart';
import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArmorAndDmgDice extends StatelessWidget {
  final Character character;

  const ArmorAndDmgDice({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          _item(
            context,
            icon: PlatformSvg.asset(
              'armor.svg',
              width: 20,
              height: 20,
              color: Get.theme.colorScheme.secondary,
            ),
            title: Text(
              'ARMOR',
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
              ),
            ),
            value: Text(
              character.armor.toString(), // +
              // '+' +
              // character.equippedDamage.toString(),
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
              ),
            ),
            onTap: () => Get.dialog(ArmorDialog(character: character)),
          ),
          _item(
            context,
            icon: DiceIcon(
              dice: character.damageDice,
              size: 20,
              color: Get.theme.colorScheme.secondary,
            ),
            title: Text(
              'DMG DICE',
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
              ),
            ),
            value: Text(
              character.damageDice.toString(),
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
              ),
            ),
            onTap: () => Get.dialog(DamageDiceDialog(character: character)),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    Widget icon,
    Widget title,
    Widget value,
    VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              title,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: icon,
              ),
              value,
            ],
          ),
        ),
      ),
    );
  }
}
