import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/lists/stat_card_grid.dart';
import 'package:dungeon_paper/src/molecules/armor_and_dmg_dice.dart';
import 'package:dungeon_paper/src/molecules/status_bars.dart';
import 'package:dungeon_paper/src/pages/home_view/photo_and_summary.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final Character character;

  HomeView({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = Get.mediaQuery.size.width;
      // ignore: unused_local_variable
      final dpr = Get.mediaQuery.devicePixelRatio;
      final shouldSplit = constraints.maxWidth > 800;
      // final height = Get.mediaQuery.size.height;

      final children = <Widget>[
        PhotoAndSummary(character: character),
        ArmorAndDmgDice(character: character),
        Padding(
          padding: const EdgeInsets.all(16).copyWith(top: 8),
          child: StatusBars(character: character),
        ),
        Padding(
          padding: const EdgeInsets.all(16).copyWith(top: 0),
          child: BaseStats(character: character),
        ),
      ];

      return ConstrainedBox(
        key: Key('$width'),
        constraints: BoxConstraints.loose(
          Size(
            shouldSplit ? double.infinity : 500,
            double.infinity,
          ),
        ),
        child: StaggeredGridView.extentBuilder(
          maxCrossAxisExtent: shouldSplit ? width / 2 : width,
          itemCount: children.length,
          itemBuilder: (context, index) => Container(
            child: children[index],
          ),
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        ),
      );
    });
  }
}
