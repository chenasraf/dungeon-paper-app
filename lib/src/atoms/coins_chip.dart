import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/dialogs/coins_dialog.dart';
import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CoinsChip extends StatelessWidget {
  final Character character;

  const CoinsChip({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Your current amount of coin. Press to update.',
      showDuration: Duration(seconds: 2),
      child: Stack(
        children: [
          ActionChip(
            onPressed: () {
              analytics.logEvent(name: Events.OpenCoinsChip);
              showDialog(
                context: context,
                builder: (context) => CoinsDialog(value: character.coins),
              );
            },
            visualDensity: VisualDensity.compact,
            backgroundColor: Color(0xFFF5EB6B),
            padding: EdgeInsets.all(8),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlatformSvg.asset(
                  'coin-stack.svg',
                  size: 20,
                ),
                SizedBox.fromSize(size: Size.square(10)),
                Text(currency(character.coins))
              ],
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
