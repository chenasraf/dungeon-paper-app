import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:dungeon_paper/src/atoms/dice_selector.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/flutter_utils/input_formatters.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassBasicDetails extends StatefulWidget {
  final VoidCallbackDelegate<CustomClass> onUpdate;
  final CustomClass customClass;
  final ValueNotifier validityNotifier;
  final DialogMode mode;

  const ClassBasicDetails({
    Key key,
    @required this.customClass,
    @required this.onUpdate,
    this.validityNotifier,
    @required this.mode,
  }) : super(key: key);

  @override
  _ClassBasicDetailsState createState() => _ClassBasicDetailsState();
}

enum Keys { name, description, baseHP, load }

class _ClassBasicDetailsState extends State<ClassBasicDetails> {
  Map<Keys, TextEditingController> editingControllers;
  Dice dice;
  bool nameDirty;

  @override
  void initState() {
    super.initState();
    nameDirty = false;

    editingControllers = WidgetUtils.textEditingControllerMap(
      list: [
        EditingControllerConfig(
          key: Keys.name,
          defaultValue: widget.customClass.name,
          listener: () {
            setState(() {
              var def = widget.customClass.copyWith(
                name: editingControllers[Keys.name].text.trim(),
              );
              updateWith(def);
              nameDirty = true;
            });
          },
        ),
        EditingControllerConfig(
          key: Keys.description,
          defaultValue: widget.customClass.description,
          listener: () {
            var def = widget.customClass.copyWith(
              description: editingControllers[Keys.description].text.trim(),
            );
            updateWith(def);
          },
        ),
        EditingControllerConfig(
          key: Keys.baseHP,
          defaultValue: (widget.customClass.baseHP ?? 0).toString(),
          listener: () {
            var def = widget.customClass.copyWith(
              baseHP:
                  int.tryParse(editingControllers[Keys.baseHP].text.trim()) ??
                      0,
            );
            updateWith(def);
          },
        ),
        EditingControllerConfig(
          key: Keys.load,
          defaultValue: (widget.customClass.load ?? 0).toString(),
          listener: () {
            var def = widget.customClass.copyWith(
              load:
                  int.tryParse(editingControllers[Keys.load].text.trim()) ?? 0,
            );
            updateWith(def);
          },
        ),
      ],
    );

    dice = widget.customClass.damage ?? Dice.d6;

    widget.validityNotifier.value = _isValid();
  }

  void updateWith(CustomClass def) {
    if (widget.validityNotifier != null) {
      widget.validityNotifier.value = _isValid();
    }
    if (widget.onUpdate != null) widget.onUpdate(def);
  }

  bool _isValid() => editingControllers[Keys.name].text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final cardCaptionStyle = Get.theme.textTheme.caption.copyWith(
      color: Get.theme.primaryColor,
    );
    final cardPadding = const EdgeInsets.all(16.0);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Name & Information', style: cardCaptionStyle),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: editingControllers[Keys.name],
                        textCapitalization: TextCapitalization.words,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Class name',
                          hintText: 'Barbarian, Paladin, Wizard...',
                          errorText: nameDirty &&
                                  editingControllers[Keys.name].text.isEmpty
                              ? 'Please enter class name'
                              : null,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: editingControllers[Keys.description],
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        minLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Class description',
                          hintText:
                              'Describe your class in free-form here.\nBe creative, everyone is watching!',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Stat Basis', style: cardCaptionStyle),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: editingControllers[Keys.baseHP],
                              inputFormatters: [NumberFormatter.int()],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Base HP',
                                hintText: '0',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                          Container(width: 24),
                          Expanded(
                            child: TextFormField(
                              controller: editingControllers[Keys.load],
                              inputFormatters: [NumberFormatter.int()],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Max Load',
                                hintText: '0',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: cardPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Damage Dice', style: Get.theme.textTheme.caption),
                      DiceSelector(
                        padding: EdgeInsets.all(0),
                        showIcon: true,
                        dice: dice,
                        onChanged: (d) => setState(() {
                          dice = d;
                          var def = widget.customClass.copyWith(
                            damage: dice,
                          );
                          updateWith(def);
                        }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
