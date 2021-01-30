import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/dialogs/add_move_or_spell_dialog.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:get/get.dart';

import 'nav_bar.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class FABData {
  final void Function() onPressed;
  final Widget icon;

  FABData({
    @required this.onPressed,
    @required this.icon,
  });
}

class FAB extends StatefulWidget {
  final PageController pageController;
  final Character character;

  const FAB({
    Key key,
    @required this.pageController,
    @required this.character,
  }) : super(key: key);

  @override
  FABState createState() => FABState(pageController: pageController);
}

class FABState extends State<FAB> {
  final PageController pageController;
  num activePageIndex;

  FABState({
    Key key,
    @required this.pageController,
  });

  @override
  void initState() {
    pageController.addListener(_pageListener);
    super.initState();
  }

  void _pageListener() {
    setState(() {
      activePageIndex = pageController.page;
    });
  }

  Color get backgroundColor => Get.theme.cardColor;
  Color get foregroundColor => Get.theme.colorScheme.secondary;

  Widget Function(BuildContext, Character) buttonsByIndex(Pages page) {
    var map = <Pages, FABData Function(BuildContext, Character)>{
      Pages.Notes: (context, character) => FABData(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed('/add-note'),
          ),
      Pages.Inventory: (context, character) => FABData(
            icon: Icon(Icons.add),
            onPressed: () => Get.toNamed('/add-item'),
          ),
      Pages.Battle: (context, character) => FABData(
            icon: Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddMoveOrSpell(
                character: character,
                defaultClass: character.mainClass,
              ),
            ),
          )
    };

    return (context, char) {
      var _item = map[page];

      if (_item == null) return null;
      var data = _item(context, char);

      return FloatingActionButton(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        child: data.icon,
        onPressed: data.onPressed,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    var activeIdx = pageController.hasClients && pageController.page != null
        ? pageController.page
        : 0.0;
    var t = (activeIdx.ceil() - activeIdx).abs();
    var rt = activeIdx.ceil() - activeIdx;
    t = lerp(t < 0.5 ? 1 - t : t / 1, 0.5, 1, 0, 1);
    rt = lerp(1 - rt, 0.5, 1, 0, 1);
    var page = Pages.values[activeIdx.round()];
    var button = buttonsByIndex(page);

    return Transform.scale(
      scale: t,
      child: Transform.rotate(
        angle: -pi * rt,
        child: activeIdx != null && button != null
            ? button(context, widget.character)
            : SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    pageController.removeListener(_pageListener);
    super.dispose();
  }
}
