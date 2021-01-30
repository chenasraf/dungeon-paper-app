import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/flutter_utils/dice_controller.dart';
import 'package:dungeon_paper/src/molecules/dice_roll_box.dart';
import 'package:dungeon_paper/src/molecules/dice_roll_builder.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class RollDiceView extends StatefulWidget {
  final Character character;
  final List<Dice> initialDiceList;
  final List<Dice> initialAddingDice;

  const RollDiceView({
    Key key,
    this.character,
    this.initialDiceList,
    this.initialAddingDice,
  }) : super(key: key);

  @override
  _RollDiceViewState createState() => _RollDiceViewState();
}

class _RollDiceViewState extends State<RollDiceView>
    with SingleTickerProviderStateMixin {
  String sessionKey;
  List<List<Dice>> diceList;
  DiceListController addingDiceCtrl;
  List<DiceListController> controllers;

  @override
  void initState() {
    diceList = [];
    controllers = [];
    addingDiceCtrl = DiceListController(
        widget.initialAddingDice?.isNotEmpty == true
            ? [...widget.initialAddingDice]
            : [Dice.d6 * 2]);
    sessionKey = generateSessionKey();

    if (widget.initialDiceList?.isNotEmpty == true) {
      _addDiceToState(widget.initialDiceList).call();
    }

    super.initState();
  }

  String generateSessionKey() => Uuid().v4();

  @override
  Widget build(BuildContext context) {
    final isLandscape = Get.mediaQuery.orientation == Orientation.landscape;

    final builder = ValueListenableBuilder(
      valueListenable: addingDiceCtrl,
      builder: (context, dice, child) => DiceRollBuilder(
        key: Key(sessionKey),
        character: widget.character,
        initialValue: dice,
        onChanged: _add,
      ),
    );

    var results = buildDiceList();
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RollDialogTitle(),
          if (isLandscape)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SingleChildScrollView(child: builder)),
                  Expanded(
                    child:
                        SingleChildScrollView(child: Column(children: results)),
                  )
                ],
              ),
            ),
          if (!isLandscape) ...[
            builder,
            Expanded(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 16),
                      ...results,
                      Container(color: Colors.red),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> buildDiceList() {
    return [
      for (var list in enumerate(reversedControllers))
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
          child: DiceRollBox(
            analyticsSource: 'Roll Dice View',
            key: Key('dice-${list.value.hash}'),
            controller: reversedControllers.elementAt(list.index),
            onRemove: () => _removeAt(list.index),
            onEdit: () => _editAt(list.index),
          ),
        ),
    ];
  }

  num reversedIndex(num idx) {
    return diceList.length - idx - 1;
  }

  Iterable<DiceListController> get reversedControllers => controllers.reversed;

  void _add(List<Dice> dice) {
    logger.d('Add dice ${dice.join(', ')}');
    analytics.logEvent(
      name: Events.AddDice,
      parameters: {'dice': dice.join(', ')},
    );
    setState(_addDiceToState(dice));
    setState(() {
      addingDiceCtrl.value = [Dice.d6 * 2];
      sessionKey = generateSessionKey();
    });
  }

  void Function() _addDiceToState(List<Dice> dice) {
    return () {
      final _ctrl = DiceListController([...dice]);
      controllers.add(_ctrl);
      diceList.add(dice);
      sessionKey = generateSessionKey();
    };
  }

  void _removeAt(num idx) {
    idx = reversedIndex(idx);
    logger.d('Remove dice ${diceList[idx].join(', ')}');
    analytics.logEvent(
      name: Events.RemoveDice,
      parameters: {'dice': diceList[idx].join(', ')},
    );
    setState(() {
      diceList.removeAt(idx);
      controllers.removeAt(idx);
      sessionKey = generateSessionKey();
    });
  }

  void _editAt(num idx) {
    idx = reversedIndex(idx);
    logger.d('Edit dice ${diceList[idx].join(', ')}');
    analytics.logEvent(
      name: Events.EditDice,
      parameters: {'dice': diceList[idx].join(', ')},
    );
    setState(() {
      addingDiceCtrl.value = List.from(diceList[idx]);
      // diceList.removeAt(idx);
      // controllers.removeAt(idx);
      logger.d('diceList: ${addingDiceCtrl.value}');
      sessionKey = generateSessionKey();
    });
  }
}

class RollDialogTitle extends StatelessWidget {
  const RollDialogTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var mq = Get.mediaQuery;
    return Container(
      height: 52,
      // width: mq.orientation == Orientation.portrait
      //     ? mq.size.width
      //     : mq.size.width / 2,
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Get.back(),
              color: Get.theme.canvasColor,
              iconSize: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  'Roll Dice',
                  textAlign: TextAlign.center,
                  style: Get.theme.textTheme.headline1.copyWith(
                    color: Get.theme.canvasColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showDiceRollView({
  Key key,
  @required String analyticsSource,
  @required Character character,
  List<Dice> initialAddingDice,
  List<Dice> initialDiceList,
}) {
  logger.d("Open Dice Dialog ${{'screen_name': analyticsSource}}");
  analytics.setCurrentScreen(screenName: ScreenNames.DiceRoll);
  analytics.logEvent(name: Events.OpenDiceDialog, parameters: {
    'screen_name': analyticsSource,
  });
  Get.dialog(
    RollDiceView(
      key: key,
      character: character,
      initialAddingDice: initialAddingDice,
      initialDiceList: initialDiceList,
    ),
    barrierColor: Colors.black.withOpacity(0.7),
  );
}

class RollDiceDialogTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve curve,
      Alignment alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Opacity(
      opacity: animation.value,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Material(
              color: Colors.black.withOpacity(0.7),
              child: GestureDetector(
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    Get.back();
                  }
                },
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, (animation.value * -50) + 50),
            child: child,
          ),
        ],
      ),
    );
  }
}
