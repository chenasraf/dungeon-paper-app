import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/inventory_item.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/lists/existing_inventory_items_list.dart';
import 'package:dungeon_paper/src/scaffolds/inventory_item_form.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class InventoryItemViewArguments {
  final InventoryItem item;
  final void Function(InventoryItem) onSave;
  final Character character;

  InventoryItemViewArguments({this.item, this.onSave, this.character});
}

class InventoryItemView extends StatefulWidget {
  final InventoryItem item;
  final DialogMode mode;
  final void Function(InventoryItem) onSave;
  final Character character;

  const InventoryItemView({
    Key key,
    @required this.item,
    @required this.mode,
    @required this.onSave,
    @required this.character,
  }) : super(key: key);

  @override
  InventoryItemViewState createState() => InventoryItemViewState();

  factory InventoryItemView.createForCharacter({Character character}) =>
      InventoryItemView(
        item: InventoryItem(key: Uuid().v4(), name: ''),
        mode: DialogMode.create,
        onSave: (item) => createInventoryItem(character, item),
        character: character,
      );
}

class InventoryItemViewState extends State<InventoryItemView>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  String search = '';

  final List<String> texts = ['Item List', 'Custom Item'];
  int tabIdx = 0;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: texts.length)
      ..addListener(() {
        setState(() {
          tabIdx = _controller.index;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InventoryItemForm(
      mode: widget.mode,
      item: widget.item,
      onSave: (item) {
        if (widget.onSave != null) {
          widget.onSave(item);
        }
        Get.back();
      },
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
        var tabBar = TabBar(
          controller: _controller,
          tabs: List.generate(
            texts.length,
            (i) => Tab(child: Text(texts[i])),
          ),
        );
        var tabBarView = TabBarView(
          controller: _controller,
          children: <Widget>[
            Container(
              key: PageStorageKey<String>(texts[0]),
              color: Get.theme.scaffoldBackgroundColor,
              child: ExistingInventoryItemsList(
                onSave: widget.onSave,
                character: widget.character,
              ),
            ),
            formContainer
          ],
        );

        var list = <Widget>[
          if (widget.mode == DialogMode.create) tabBar,
          Expanded(
            child:
                widget.mode == DialogMode.create ? tabBarView : formContainer,
          ),
        ];

        return MainScaffold(
          useElevation: false,
          wrapWithScrollable: false,
          elevation: 0.0,
          title:
              Text('${widget.mode == DialogMode.create ? 'Add' : 'Edit'} Item'),
          actions: tabIdx == texts.length - 1 || widget.mode == DialogMode.edit
              ? actions
              : [],
          body: Column(
            children: list,
          ),
        );
      },
    );
  }
}
