import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/molecules/current_stat_indicator.dart';
import 'package:dungeon_paper/src/molecules/status_bars.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';
import 'package:wheel_spinner/wheel_spinner.dart';
import 'package:flutter/material.dart';

import 'standard_dialog_controls.dart';

class XpDialog extends StatefulWidget {
  final Character character;
  static const int MIN_ROW_WIDTH = 410;

  const XpDialog({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  _XpDialogState createState() => _XpDialogState();
}

class _XpDialogState extends State<XpDialog> {
  int currentXP;
  int initialCurrentXP;

  @override
  void initState() {
    currentXP = widget.character.currentXP ?? 0;
    initialCurrentXP = currentXP;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.mediaQuery.size.width;
    final maxXP = widget.character.level + 7;
    Widget indicator = Container(
      height: 110,
      child: currentXP < maxXP && currentXP > 0
          ? CurrentStatIndicator(
              initialValue: initialCurrentXP,
              value: currentXP,
              label: 'XP',
              differenceTextBuilder: (above) => above ? 'Add' : 'Reduce',
            )
          : Center(
              child: RaisedButton(
                color: Get.theme.primaryColor,
                child: Text(currentXP > 0 ? 'Level Up' : 'Level Down'),
                onPressed: currentXP == 0 && widget.character.level == 1
                    ? null
                    : () =>
                        currentXP > 0 ? levelUp(context) : levelDown(context),
              ),
            ),
    );
    Widget spinner = Container(
      height: 100,
      child: WheelSpinner(
        key: Key('${widget.character.level}-spinner'),
        min: 0.0,
        max: maxXP.toDouble(),
        value: currentXP.toDouble(),
        minMaxLabelBuilder: (value) => value.toInt().toString(),
        onSlideUpdate: updateValue,
      ),
    );
    return AlertDialog(
      title: Text('Manage XP'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0)
                  .copyWith(top: 10.0),
              child: StatusBarInfo(
                value: currentXP / maxXP,
                minNum: currentXP.toString(),
                maxNum: maxXP.toString(),
                barBackgroundColor: Colors.lightBlue.shade100,
                barForegroundColor: Colors.blue,
              ),
            ),
            Container(
              width: screenWidth >= XpDialog.MIN_ROW_WIDTH
                  ? XpDialog.MIN_ROW_WIDTH.toDouble()
                  : 200.0,
              padding: const EdgeInsets.all(32.0).copyWith(bottom: 0),
              child: screenWidth >= XpDialog.MIN_ROW_WIDTH
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(child: indicator),
                        Expanded(child: spinner),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        indicator,
                        spinner,
                      ],
                    ),
            ),
          ],
        ),
      ),
      actions: StandardDialogControls.actions(
        context: context,
        cancelText: Text('Close'),
        onConfirm: () => _save(context),
        confirmDisabled: currentXP == maxXP,
      ),
    );
  }

  void updateValue(val) {
    setState(() {
      currentXP = val.toInt();
    });
  }

  void _save(BuildContext context) {
    analytics.logEvent(name: Events.SaveXP);
    unawaited(
      widget.character
          .copyWith(
        currentXP: currentXP,
      )
          .update(keys: ['currentXP']),
    );
    Get.back();
  }

  void levelUp(BuildContext context) async {
    unawaited(analytics.logEvent(name: Events.LevelUp));
    final char = widget.character.copyWith(
      currentXP: 0,
      level: widget.character.level + 1,
    );
    unawaited(char.update(keys: ['currentXP', 'level']));
    setState(() {
      currentXP = char.currentXP;
      initialCurrentXP = currentXP;
    });
    return showDialog(
      context: context,
      builder: (context) => LevelUpDialog(char: char),
    );
  }

  void levelDown(BuildContext context) async {
    unawaited(analytics.logEvent(name: Events.LevelDown));
    final char = widget.character.copyWith(
        currentXP: widget.character.level + 5,
        level: widget.character.level - 1);
    unawaited(char.update(keys: ['currentXP', 'level']));
    setState(() {
      currentXP = char.currentXP;
      initialCurrentXP = currentXP;
    });
    return showDialog(
      context: context,
      builder: (context) => LevelUpDialog(char: char, levelDown: true),
    );
  }
}

class LevelUpDialog extends StatelessWidget {
  const LevelUpDialog({
    Key key,
    @required this.char,
    this.levelDown = false,
  }) : super(key: key);

  final Character char;
  final bool levelDown;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(!levelDown ? 'Woah! Congratulations!' : 'Wait, what?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('You are now level ${char.level}!'),
            ),
          ],
        ),
      ),
      actions: [
        RaisedButton(
          child: Text('Continue'),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}
