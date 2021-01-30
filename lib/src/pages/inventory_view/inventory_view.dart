import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/inventory_item.dart';
import 'package:dungeon_paper/src/atoms/equipped_armor_chip.dart';
import 'package:dungeon_paper/src/atoms/flexible_columns.dart';
import 'package:dungeon_paper/src/atoms/coins_chip.dart';
import 'package:dungeon_paper/src/atoms/damage_chip.dart';
import 'package:dungeon_paper/src/atoms/empty_state.dart';
import 'package:dungeon_paper/src/atoms/inventory_load_chip.dart';
import 'package:dungeon_paper/src/atoms/search_bar.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/molecules/inventory_item_card.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum EquipmentCats {
  Stats,
  EquippedItems,
  UnequippedItems,
}

const EquipmentTitles = {
  EquipmentCats.Stats: null,
  EquipmentCats.EquippedItems: Text('Equipped'),
  EquipmentCats.UnequippedItems: Text('Posessions'),
};

class InventoryView extends StatefulWidget {
  final Character character;

  const InventoryView({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  _InventoryViewState createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController()..addListener(_searchListener);
  }

  @override
  Widget build(BuildContext context) {
    final emptyState = EmptyState(
      title: Text('Your inventory is empty'),
      subtitle: Text("Use the '+' button to add things to your possession."),
      assetName: 'bag.svg',
    );
    final isShort = Get.mediaQuery.size.height < 420;

    if (_equipmentGrouped.values.every((i) => i == null || i.isEmpty)) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: InventoryInfoBar(character: widget.character),
            ),
            SizedBox(height: 16),
            isShort
                ? emptyState
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: Get.mediaQuery.size.height - 300,
                    ),
                    child: emptyState,
                  ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: FlexibleColumns.builder(
            keyBuilder: (ctx, key, idx) => 'InventoryView.' + enumName(key),
            itemCount: (cat, idx) => cat != EquipmentCats.Stats
                ? _equipmentFiltered[_catToKey(cat)].length
                : 1,
            titleBuilder: (ctx, cat, i) => EquipmentTitles[cat],
            topSpacerHeight: 50,
            itemBuilder: _itemBuilder,
            items: [
              EquipmentCats.Stats,
              EquipmentCats.EquippedItems,
              EquipmentCats.UnequippedItems,
            ],
            bottomSpacerHeight: BOTTOM_SPACER.height,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBar(
            controller: searchController,
            hintText: 'Type to search items',
          ),
        ),
      ],
    );
  }

  Map<String, List<InventoryItem>> get _equipmentGrouped =>
      <String, List<InventoryItem>>{'equipped': [], 'unequipped': []}
        ..addAll(groupBy(
          widget.character.inventory,
          (i) => i.equipped == true ? 'equipped' : 'unequipped',
        ));

  Map<String, List<InventoryItem>> get _equipmentFiltered {
    return Map.from(
      _equipmentGrouped.map(
        (key, value) => MapEntry(key, value.where(_isVisible).toList()),
      ),
    );
  }

  String _catToKey(EquipmentCats cat) => cat == EquipmentCats.EquippedItems
      ? 'equipped'
      : cat == EquipmentCats.UnequippedItems
          ? 'unequipped'
          : null;

  Widget _itemBuilder(BuildContext ctx, EquipmentCats cat, num i, num catI) {
    if (cat == EquipmentCats.Stats) {
      return InventoryInfoBar(character: widget.character);
    }

    final item = _equipmentFiltered[_catToKey(cat)][i];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: InventoryItemCard(
        key: PageStorageKey(item.key),
        item: item,
        mode: InventoryItemCardMode.editable,
        onSave: (item) => updateInventoryItem(widget.character, item),
        onDelete: () => deleteInventoryItem(widget.character, item),
        character: widget.character,
      ),
    );
  }

  void _searchListener() {
    setState(() {});
  }

  bool _isVisible(InventoryItem item) =>
      searchController.text.isEmpty ||
      _matchStr(item.name) ||
      _matchStr(item.description) ||
      _matchStr(item.tags.map((t) => t.toJSON().toString()).join(', '));

  bool _matchStr(String str) => (str ?? '')
      .toLowerCase()
      .contains(searchController.text.toLowerCase().trim());
}

class InventoryInfoBar extends StatelessWidget {
  const InventoryInfoBar({
    Key key,
    @required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // alignment: Alignment.centerLeft,
      spacing: 5,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DamageChip(character: character),
        EquippedArmorChip(character: character),
        InventoryLoadChip(character: character),
        CoinsChip(character: character),
      ],
    );
  }
}
