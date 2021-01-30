import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/dialogs/armor_dialog.dart';
import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EquippedArmorChip extends StatelessWidget {
  final Character character;

  const EquippedArmorChip({
    Key key,
    @required this.character,
  }) : super(key: key);

  int get armor => character.equippedArmor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          'This is auto calculated from "Armor" tags\non equipped inventory items.\nPress to override with a custom value.',
      showDuration: Duration(seconds: 3),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ActionChip(
            visualDensity: VisualDensity.compact,
            backgroundColor: Colors.grey[700],
            padding: EdgeInsets.all(8),
            onPressed: () => Get.dialog(ArmorDialog(character: character)),
            label: IconTheme(
              data: IconThemeData(color: Colors.white),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: Colors.white),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('EQP. ARMOR'),
                    SizedBox(width: 10),
                    PlatformSvg.asset(
                      'armor.svg',
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(armor.toString()),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Material(
              shape: CircleBorder(),
              color: Get.theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.edit,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
