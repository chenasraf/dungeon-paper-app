import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerClassList extends StatelessWidget {
  final Widget Function(BuildContext, List<PlayerClass>) builder;
  final bool includeCustom;
  final bool includeDefault;

  const PlayerClassList({
    Key key,
    @required this.builder,
    this.includeCustom = true,
    this.includeDefault = true,
  }) : super(key: key);

  factory PlayerClassList.dropdown({
    PlayerClass value,
    bool includeCustom = true,
    bool includeDefault = true,
    @required void Function(PlayerClass) onChanged,
  }) =>
      PlayerClassList(
        includeCustom: includeCustom,
        includeDefault: includeDefault,
        builder: (context, list) => DropdownButton(
          isExpanded: true,
          value: list.firstWhere((cls) => cls.key == value.key,
              orElse: () => list.first),
          onChanged: onChanged,
          items: [
            for (var cls in list)
              DropdownMenuItem(value: cls, child: Text(cls.name)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final _dw = dungeonWorld.classes;
        final _custom = customClassesController.classes.values
            .map((cls) => cls.toPlayerClass());
        return builder(context, [
          if (includeDefault) ..._dw,
          if (includeCustom) ..._custom,
        ]);
      },
    );
  }
}
