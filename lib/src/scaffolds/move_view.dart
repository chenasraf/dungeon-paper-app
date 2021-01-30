import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/move.dart';
import 'package:dungeon_paper/src/builders/custom_move_form_builder.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/lists/add_move_list.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MoveViewArguments {
  final Move move;
  final void Function(Move move) onSave;

  MoveViewArguments({
    this.move,
    this.onSave,
  });
}

class MoveView extends StatefulWidget {
  const MoveView({
    Key key,
    @required this.move,
    @required this.mode,
    @required this.onSave,
    this.defaultClass,
  }) : super(key: key);

  final Move move;
  final DialogMode mode;
  final void Function(Move move) onSave;
  final PlayerClass defaultClass;

  @override
  MoveViewState createState() => MoveViewState();

  factory MoveView.createForCharacter({
    @required Character character,
  }) =>
      MoveView(
        move: Move(
          key: Uuid().v4(),
          name: '',
          description: '',
          classes: [],
          explanation: '',
        ),
        mode: DialogMode.create,
        onSave: (move) {
          createMove(character, move);
          Get.back();
        },
        defaultClass: character.mainClass,
      );
}

class MoveViewState extends State<MoveView>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  MoveViewState() {
    _controller = TabController(vsync: this, length: texts.length);
  }

  final List<String> texts = ['Class Moves', 'Custom Move'];
  int tabIdx = 0;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        tabIdx = _controller.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMoveFormBuilder(
      mode: widget.mode,
      move: widget.move,
      onSave: widget.onSave,
      builder: (ctx, form, onSave) {
        var actions = <Widget>[
          IconButton(
            tooltip: 'Save',
            icon: Icon(Icons.save),
            onPressed: onSave,
          ),
        ];
        var formContainer = Container(
          color: Get.theme.scaffoldBackgroundColor,
          child: SingleChildScrollView(
            key: PageStorageKey<String>(texts[1]),
            padding: EdgeInsets.all(16),
            child: form,
          ),
        );
        var tabBarView = TabBarView(
          controller: _controller,
          children: <Widget>[
            AddMoveList(
              key: PageStorageKey<String>(texts[0]),
              playerClass: widget.defaultClass,
              onSave: widget.onSave,
            ),
            formContainer,
          ],
        );
        var tabBar = TabBar(
          controller: _controller,
          tabs: List.generate(
            texts.length,
            (i) => Tab(child: Text(texts[i])),
          ),
        );

        var list = <Widget>[
          Expanded(
            child:
                widget.mode == DialogMode.create ? tabBarView : formContainer,
          ),
        ];
        if (widget.mode == DialogMode.create) {
          list.insert(0, tabBar);
        }

        return MainScaffold(
          useElevation: false,
          wrapWithScrollable: false,
          elevation: 0.0,
          title:
              Text('${widget.mode == DialogMode.create ? 'Add' : 'Edit'} Move'),
          actions: tabIdx == 1 || widget.mode == DialogMode.edit ? actions : [],
          body: Column(
            children: list,
          ),
        );
      },
    );
  }
}
