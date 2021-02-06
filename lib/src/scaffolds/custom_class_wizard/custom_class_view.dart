import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/lists/custom_class_moves_list.dart';
import 'package:dungeon_paper/src/molecules/custom_class_alignments.dart';
import 'package:dungeon_paper/src/molecules/custom_class_basic_details.dart';
import 'package:dungeon_paper/src/molecules/custom_class_looks.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';

class CustomClassViewArguments {
  final CustomClass customClass;
  final void Function(CustomClass) onSave;

  CustomClassViewArguments({
    this.customClass,
    this.onSave,
  });
}

class CustomClassView extends StatefulWidget {
  final DialogMode mode;
  final CustomClass customClass;
  final void Function(CustomClass) onSave;

  const CustomClassView({
    Key key,
    @required this.mode,
    this.customClass,
    this.onSave,
  })  : assert(mode == DialogMode.create || customClass != null),
        super(key: key);

  @override
  _CustomClassViewState createState() => _CustomClassViewState();
}

enum CustomClassWizardTab { basicInfo, moves, races, looks, alignments }

class _CustomClassViewState extends State<CustomClassView>
    with SingleTickerProviderStateMixin {
  CustomClass def;
  TabController tabController;
  ValueNotifier<bool> basicInfoValid;
  ValueNotifier<bool> movesValid;
  ValueNotifier<bool> racesValid;
  ValueNotifier<bool> looksValid;
  ValueNotifier<bool> alignmentsValid;
  bool dirty;

  static const Map<CustomClassWizardTab, String> TAB_TITLES = {
    CustomClassWizardTab.basicInfo: 'General',
    CustomClassWizardTab.moves: 'Moves',
    CustomClassWizardTab.races: 'Races',
    CustomClassWizardTab.looks: 'Look Choices',
    CustomClassWizardTab.alignments: 'Alignments',
  };

  @override
  void initState() {
    var user = userController.current;
    def = widget.customClass != null
        ? widget.customClass.copyWith(
            ref: widget.customClass.ref ??
                user.ref.collection('custom_classes').doc(),
          )
        : CustomClass(
            key: Uuid().v4(),
            ref: user.ref.collection('custom_classes').doc(),
          );

    basicInfoValid = ValueNotifier(def.name.isNotEmpty);
    racesValid = ValueNotifier(def.raceMoves.isNotEmpty);
    movesValid = ValueNotifier(true);
    looksValid = ValueNotifier(true);
    alignmentsValid = ValueNotifier(true);
    dirty = false;

    tabController = TabController(length: _tabs.keys.length, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: MainScaffold(
        title: Text(def.name.isEmpty
            ? 'Custom Class'
            : '${widget.mode == DialogMode.create ? 'Creat' : 'Edit'}ing: ${def.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _isClsValid ? _save : null,
          )
        ],
        wrapWithScrollable: false,
        useElevation: false,
        elevation: 0,
        automaticallyImplyLeading: true,
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Get.theme.primaryColor,
                      child: TabBar(
                        isScrollable: true,
                        controller: tabController,
                        tabs: _tabs.keys.map(_mapTab).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: _tabs.values.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab _mapTab(CustomClassWizardTab k) => Tab(
        child: Container(
          constraints: BoxConstraints(maxWidth: 150),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(TAB_TITLES[k]),
              if (!_isValid(k))
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.error,
                    color: Colors.orange[300],
                  ),
                ),
            ],
          ),
        ),
      );

  Map<CustomClassWizardTab, Widget> get _tabs => {
        CustomClassWizardTab.basicInfo: ClassBasicDetails(
          mode: widget.mode,
          customClass: def,
          validityNotifier: basicInfoValid,
          onUpdate: (cls) => setState(() {
            dirty = true;
            def = def.copyWith(
              name: cls.name,
              baseHP: cls.baseHP,
              damage: cls.damage,
            );
          }),
        ),
        CustomClassWizardTab.races: CustomClassMoveList(
          mode: widget.mode,
          customClass: def,
          validityNotifier: racesValid,
          raceMoveMode: true,
          onUpdate: (cls) => setState(() {
            dirty = true;
            def = def.copyWith(raceMoves: cls.raceMoves);
          }),
        ),
        CustomClassWizardTab.moves: CustomClassMoveList(
          mode: widget.mode,
          customClass: def,
          validityNotifier: movesValid,
          raceMoveMode: false,
          onUpdate: (cls) => setState(() {
            dirty = true;
            def = def.copyWith(
              startingMoves: cls.startingMoves,
              advancedMoves1: cls.advancedMoves1,
              advancedMoves2: cls.advancedMoves2,
            );
          }),
        ),
        CustomClassWizardTab.looks: CustomClassLooks(
          mode: widget.mode,
          looks: def.looks,
          validityNotifier: looksValid,
          onUpdate: (looks) => setState(() {
            dirty = true;
            def = def.copyWith(
              looks: Map<String, List<String>>.from(
                looks.asMap().map(
                      (k, v) => MapEntry(k.toString(), v),
                    ),
              ),
            );
          }),
        ),
        CustomClassWizardTab.alignments: CustomClassAlignments(
          mode: widget.mode,
          alignments: def.alignments,
          onUpdate: (alignments) => setState(() {
            dirty = true;
            def = def.copyWith(alignments: alignments);
          }),
        ),
      };

  bool _isValid(CustomClassWizardTab k) {
    switch (k) {
      case CustomClassWizardTab.basicInfo:
        return basicInfoValid.value;
      case CustomClassWizardTab.moves:
        return movesValid.value;
      case CustomClassWizardTab.races:
        return racesValid.value;
      case CustomClassWizardTab.looks:
        return looksValid.value;
      case CustomClassWizardTab.alignments:
        return alignmentsValid.value;
    }
    return true;
  }

  bool get _isClsValid => [
        basicInfoValid,
        racesValid,
        movesValid,
        looksValid,
        alignmentsValid,
      ].every((validator) => validator.value == true);

  void _save() async {
    unawaited(analytics.logEvent(
      name: Events.SaveCustomClass,
      parameters: {
        'mode': enumName(widget.mode).toLowerCase(),
      },
    ));
    if (widget.mode == DialogMode.create) {
      await def.create();
    } else {
      await def.update();
    }
    widget.onSave?.call(def);
    Get.back();
  }

  Future<bool> _confirmExit() async {
    var verb = widget.mode == DialogMode.edit ? 'edit' : 'creation';
    if (!dirty) {
      return true;
    }
    if (await showDialog(
          context: context,
          builder: (ctx) => ConfirmationDialog(
            text: Text(
              'Are you sure you want to quit custom class $verb?\n'
              'Your changes will not be saved.',
            ),
          ),
        ) ==
        true) {
      Get.back(result: true);
      return true;
    }
    return false;
  }
}
