import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/dialogs/change_alignment_dialog.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/scaffolds/class_select_view.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';
import 'basic_info_view.dart';
import 'select_race_move_view.dart';
import 'looks_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'character_stats.dart';

enum CreateCharacterTab {
  BasicInfo,
  MainClass,
  Alignment,
  Race,
  Looks,
  Stats,
}

class CharacterViewArguments {
  final Character character;
  final void Function(Character) onSave;

  CharacterViewArguments({
    this.character,
    this.onSave,
  });
}

class CharacterView extends StatefulWidget {
  final DialogMode mode;
  final Character character;
  final void Function(Character) onSave;

  const CharacterView({
    Key key,
    @required this.mode,
    @required this.character,
    this.onSave,
  }) : super(key: key);

  @override
  _CharacterViewState createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView>
    with SingleTickerProviderStateMixin {
  Character character;
  TabController tabController;
  ValueNotifier<bool> basicInfoValid;
  ValueNotifier<bool> mainClassValid;
  ValueNotifier<bool> alignmentValid;
  ValueNotifier<bool> raceValid;
  ValueNotifier<bool> looksValid;
  ValueNotifier<bool> statsValid;
  bool dirty;

  static const Map<CreateCharacterTab, String> TAB_TITLES = {
    CreateCharacterTab.BasicInfo: 'General',
    CreateCharacterTab.MainClass: 'Class',
    CreateCharacterTab.Alignment: 'Alignment',
    CreateCharacterTab.Race: 'Race',
    CreateCharacterTab.Looks: 'Looks',
    CreateCharacterTab.Stats: 'Stats',
  };

  @override
  void initState() {
    final user = userController.current;
    character = widget.character != null
        ? Character.fromJson(
            widget.character.toJson(),
            ref:
                widget.character.ref ?? user.ref.collection('characters').doc(),
          )
        : Character(
            key: Uuid().v4(),
            ref: user.ref.collection('characters').doc(),
            playerClass: dungeonWorld.classes.first,
          );

    basicInfoValid = ValueNotifier(character.displayName.isNotEmpty);
    mainClassValid = ValueNotifier(character.playerClass != null);
    alignmentValid = ValueNotifier(character.alignment != null);
    raceValid = ValueNotifier(character.race != null);
    looksValid = ValueNotifier(true);
    statsValid = ValueNotifier(true);
    dirty = false;

    tabController = TabController(length: _tabs.keys.length, vsync: this);
    logger.d('Page View: ${Routes.characterEdit.analyticsName}');
    analytics.setCurrentScreen(screenName: Routes.characterEdit.analyticsName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: MainScaffold(
        title: Text(character.displayName.isEmpty
            ? 'Character'
            : '${widget.mode == DialogMode.create ? 'Creat' : 'Edit'}ing: ${character.displayName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _isCharValid ? _save : null,
          )
        ],
        wrapWithScrollable: false,
        useElevation: false,
        automaticallyImplyLeading: true,
        elevation: 0,
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBar(
                      isScrollable: true,
                      controller: tabController,
                      tabs: _tabs.keys.map(_mapTab).toList(),
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

  Tab _mapTab(CreateCharacterTab k) => Tab(
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

  Map<CreateCharacterTab, Widget> get _tabs => {
        CreateCharacterTab.BasicInfo: EditBasicInfoView(
          character: character,
          mode: DialogMode.create,
          onUpdate: (char) => setState(() {
            dirty = true;
            character = character.copyWith(
              displayName: char.displayName,
              photoURL: char.photoURL,
              bio: char.bio,
            );
          }),
        ),
        CreateCharacterTab.MainClass: ClassSelectView(
          character: character,
          mode: DialogMode.create,
          onUpdate: (char) => setState(() {
            dirty = true;
            character = character.copyWith(
              playerClass: char.playerClass,
            );
          }),
        ),
        CreateCharacterTab.Alignment: ChangeAlignmentDialog(
          character: character,
          mode: DialogMode.create,
          onUpdate: (char) => setState(() {
            dirty = true;
            character = char;
          }),
        ),
        CreateCharacterTab.Race: SelectRaceMoveView(
          character: character,
          mode: DialogMode.create,
          onUpdate: (char) => setState(() {
            dirty = true;
            character = char;
          }),
        ),
        CreateCharacterTab.Looks: LooksView(
          character: character,
          mode: DialogMode.create,
          onUpdate: (char) => setState(() {
            dirty = true;
            character = character.copyWith(looks: char.looks);
          }),
        ),
        CreateCharacterTab.Stats: CharacterStats(
          character: character,
          onUpdate: (char) => setState(() {
            dirty = true;
            character = char;
          }),
        ),
      };

  bool _isValid(CreateCharacterTab k) {
    switch (k) {
      case CreateCharacterTab.BasicInfo:
        return basicInfoValid.value;
      case CreateCharacterTab.MainClass:
        return mainClassValid.value;
      case CreateCharacterTab.Alignment:
        return alignmentValid.value;
      case CreateCharacterTab.Race:
        return raceValid.value;
      case CreateCharacterTab.Looks:
        return looksValid.value;
      case CreateCharacterTab.Stats:
        return statsValid.value;
    }
    return true;
  }

  bool get _isCharValid => [
        basicInfoValid,
        mainClassValid,
        alignmentValid,
        raceValid,
        looksValid,
        statsValid,
      ].every((validator) => validator.value == true);

  void _save() async {
    unawaited(analytics.logEvent(
      name: Events.SaveCharacter,
      parameters: {
        'mode': enumName(widget.mode).toLowerCase(),
      },
    ));
    unawaited(
      widget.mode == DialogMode.create
          ? character.copyWith(customCurrentHP: character.defaultMaxHP).create()
          : character.update(),
    );
    widget.onSave?.call(character);
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
                  'Are you sure you want to quit character $verb?\nYour changes will not be saved.')),
        ) ==
        true) {
      Get.back(result: true);
      return true;
    }
    return false;
  }
}

class GenericAppBarActionButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;

  const GenericAppBarActionButton({
    Key key,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(left: 4.0),
      child: RaisedButton(
        child: child,
        color: Get.theme.canvasColor,
        onPressed: onPressed,
      ),
    );
  }
}
