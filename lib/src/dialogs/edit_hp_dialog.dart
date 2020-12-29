import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/molecules/current_stat_indicator.dart';
import 'package:dungeon_paper/src/molecules/status_bars.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:get/get.dart';
import 'package:wheel_spinner/wheel_spinner.dart';
import 'package:flutter/material.dart';

import 'standard_dialog_controls.dart';

class EditHPDialog extends StatefulWidget {
  final Character character;
  static const int MIN_ROW_WIDTH = 410;

  const EditHPDialog({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  _EditHPDialogState createState() => _EditHPDialogState();
}

enum HPMode { HP, MaxHP }

class _EditHPDialogState extends State<EditHPDialog> {
  int currentHP;
  int maxHP;
  int initialCurrentHP;
  int initialMaxHP;
  bool useDefaultMaxHP;
  HPMode mode;

  @override
  void initState() {
    currentHP = widget.character.currentHP ?? 0;
    maxHP = widget.character.maxHP ?? 0;
    initialCurrentHP = currentHP;
    initialMaxHP = maxHP;
    useDefaultMaxHP = widget.character.useDefaultMaxHP;
    mode = HPMode.HP;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hpTitles = {
      HPMode.HP: 'HP' + (currentHP != widget.character.currentHP ? ' *' : ''),
      HPMode.MaxHP: 'Max HP' + (maxHP != widget.character.maxHP ? ' *' : ''),
    };
    final Widget title = Row(
      children: <Widget>[
        Expanded(child: Text('Manage HP')),
        Text(
          'Editing: ',
          style: Get.theme.textTheme.bodyText2,
        ),
        SizedBox(width: 4),
        DropdownButton(
          value: mode,
          onChanged: changeMode,
          items: [
            for (HPMode mode in hpTitles.keys)
              DropdownMenuItem(
                value: mode,
                child: Text(hpTitles[mode]),
              ),
          ],
        ),
      ],
    );
    var screenWidth = MediaQuery.of(context).size.width;
    Widget indicator = Container(
      height: 110,
      child: CurrentStatIndicator(
        initialValue: isHP ? initialCurrentHP : initialMaxHP,
        value: isHP ? currentHP : maxHP,
        label: isHP ? 'HP' : 'Max HP',
        differenceTextBuilder: (above) => isHP
            ? above
                ? 'Heal'
                : 'Damage'
            : above
                ? 'Add'
                : 'Reduce',
      ),
    );
    Widget spinner = Container(
      height: 100,
      child: WheelSpinner(
        key: Key(enumName(mode)),
        min: isHP ? 0.0 : 1.0,
        max: isHP ? maxHP.toDouble() : double.infinity,
        value: isHP ? currentHP.toDouble() : maxHP.toDouble(),
        minMaxLabelBuilder: (value) => value.toInt().toString(),
        onSlideUpdate: updateValue,
      ),
    );
    return AlertDialog(
      title: title,
      contentPadding: EdgeInsets.only(top: isMaxHP ? 0 : 32, bottom: 8),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isMaxHP)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: useDefaultMaxHP,
                  title: Text('Calculate based on stats'),
                  subtitle: Text(
                      'Class Base HP (${widget.character.mainClass.baseHP}) + Constitution (${widget.character.con})'),
                  onChanged: (val) {
                    if (val) updateValue(widget.character.defaultMaxHP);
                    setState(() {
                      useDefaultMaxHP = val;
                    });
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: StatusBarInfo(
                value: currentHP / maxHP,
                minNum: currentHP.toString(),
                maxNum: maxHP.toString(),
                barBackgroundColor: Colors.red.shade100,
                barForegroundColor: Colors.red.shade700,
              ),
            ),
            if (isHP || !useDefaultMaxHP)
              Container(
                width: screenWidth >= EditHPDialog.MIN_ROW_WIDTH
                    ? EditHPDialog.MIN_ROW_WIDTH.toDouble()
                    : 200.0,
                // height: screenWidth >= HPEditDialog.MIN_ROW_WIDTH ? null : 250,
                padding: const EdgeInsets.only(top: 32.0),
                child: screenWidth >= EditHPDialog.MIN_ROW_WIDTH
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
        onConfirm: () => _save(context),
      ),
    );
  }

  bool get isHP => mode == HPMode.HP;
  bool get isMaxHP => mode == HPMode.MaxHP;

  void updateValue(val) {
    setState(() {
      if (isHP) {
        currentHP = val.toInt();
      } else {
        maxHP = val.toInt();
        if (maxHP < currentHP) {
          currentHP = maxHP;
        }
      }
    });
  }

  void _save(BuildContext context) {
    analytics.logEvent(name: Events.SaveHP);
    widget.character
      ..currentHP = currentHP
      ..maxHP = maxHP
      ..useDefaultMaxHP = useDefaultMaxHP
      ..update();
    Get.back();
  }

  void changeMode(HPMode mode) {
    setState(() {
      this.mode = mode;
    });
  }
}
