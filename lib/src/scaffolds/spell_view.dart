import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/spell.dart';
import 'package:dungeon_paper/src/builders/custom_spell_form_builder.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/lists/add_spell_list.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SpellViewArguments {
  final DbSpell spell;
  final void Function(DbSpell move) onSave;

  SpellViewArguments({
    this.spell,
    this.onSave,
  });
}

class SpellView extends StatefulWidget {
  const SpellView({
    Key key,
    @required this.spell,
    @required this.mode,
    @required this.onSave,
  }) : super(key: key);

  final DbSpell spell;
  final DialogMode mode;
  final void Function(DbSpell move) onSave;

  @override
  SpellViewState createState() => SpellViewState();

  factory SpellView.createForCharacter({
    @required Character character,
  }) =>
      SpellView(
        spell: DbSpell(
          key: Uuid().v4(),
          name: '',
          description: '',
          tags: [],
          level: '1',
        ),
        mode: DialogMode.create,
        onSave: (spell) {
          createSpell(character, spell);
          Get.back();
        },
      );
}

class SpellViewState extends State<SpellView>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  SpellViewState() {
    _controller = TabController(vsync: this, length: texts.length);
  }

  final List<String> texts = ['Spellbook', 'Custom Spell'];
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
    return CustomSpellFormBuilder(
      mode: widget.mode,
      spell: widget.spell,
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
          color: Get.theme.primaryColor,
          child: SingleChildScrollView(
            key: PageStorageKey<String>(texts[1]),
            padding: EdgeInsets.all(16),
            child: form,
          ),
        );
        var tabBarView = TabBarView(
          controller: _controller,
          children: <Widget>[
            Container(
              color: Get.theme.scaffoldBackgroundColor,
              child: AddSpellList(
                key: PageStorageKey<String>(texts[1]),
                onSave: widget.onSave,
              ),
            ),
            formContainer,
          ],
        );
        var tabBar = Container(
          color: Get.theme.scaffoldBackgroundColor,
          child: TabBar(
            controller: _controller,
            tabs: List.generate(
              texts.length,
              (i) => Tab(child: Text(texts[i])),
            ),
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
          title: Text(
              '${widget.mode == DialogMode.create ? 'Add' : 'Edit'} Spell'),
          actions: tabIdx == 1 || widget.mode == DialogMode.edit ? actions : [],
          body: Column(
            // mainAxisSize: MainAxisSize.max,
            children: list,
          ),
        );
      },
    );
  }
}
