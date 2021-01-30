import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/inventory_item.dart';
import 'package:dungeon_paper/src/atoms/card_bottom_controls.dart';
import 'package:dungeon_paper/src/atoms/dice_icon.dart';
import 'package:dungeon_paper/src/atoms/icon_chip.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/lists/tag_list.dart';
import 'package:dungeon_paper/src/scaffolds/inventory_item_view.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

enum InventoryItemCardMode { addable, editable }

class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final InventoryItemCardMode mode;
  final void Function(InventoryItem) onSave;
  final void Function() onDelete;
  final Character character;

  InventoryItemCard({
    Key key,
    @required this.item,
    @required this.mode,
    @required this.onSave,
    @required this.onDelete,
    @required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var amount = item.amount;

    var info = <Widget>[];
    if (item.description != null && item.description.trim().isNotEmpty) {
      info.add(
        MarkdownBody(
          onTapLink: (text, url, _title) => _launchURL(url),
          data: item.description,
          listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
        ),
      );
    }
    if (item.tags?.isNotEmpty == true) {
      info.add(TagList(
        tags: item.tags,
        visualDensity: VisualDensity.compact,
      ));
    }

    var titleChildren = <Widget>[
      Expanded(
        child: Text(
          item.name ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
    if (mode == InventoryItemCardMode.editable && item.equipped == true) {
      titleChildren.addAll([
        Chip(
          visualDensity: VisualDensity.compact,
          backgroundColor: Colors.orange[300],
          label: Text('Equipped'),
          padding: EdgeInsets.all(0),
          // labelPadding: EdgeInsets.all(0),
        ),
        SizedBox(width: 10),
      ]);
    }
    if (mode == InventoryItemCardMode.editable) {
      titleChildren.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('x$amount'),
      ));
    }

    var title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: titleChildren,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        key: PageStorageKey('inv-${item.key}'),
        title: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 45),
          child: title,
        ),
        subtitle: [item.damage, item.armor, item.weight].any((i) => i != 0)
            ? Wrap(
                spacing: 4,
                children: [
                  if (item.damage != 0)
                    IconChip(
                      visualDensity: VisualDensity.compact,
                      spacing: 4,
                      icon: DiceIcon(
                        dice: character.damageDice,
                        size: 14,
                      ),
                      label: Text(
                        (item.damage >= 0 ? '+' : '-') + commatize(item.damage),
                        textScaleFactor: 0.8,
                      ),
                    ),
                  if (item.armor != 0)
                    IconChip(
                      visualDensity: VisualDensity.compact,
                      spacing: 4,
                      icon: PlatformSvg.asset(
                        'armor.svg',
                        size: 14,
                      ),
                      label: Text(
                        commatize(item.armor),
                        textScaleFactor: 0.8,
                      ),
                    ),
                  if (item.weight != 0)
                    IconChip(
                      visualDensity: VisualDensity.compact,
                      spacing: 4,
                      icon: PlatformSvg.asset(
                        'dumbbell.svg',
                        size: 14,
                      ),
                      label: Text(
                        commatize(item.weight),
                        textScaleFactor: 0.8,
                      ),
                    ),
                ],
              )
            : null,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                .copyWith(
                    bottom: mode == InventoryItemCardMode.editable ? 0 : 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: info,
            ),
          ),
          if (mode == InventoryItemCardMode.editable)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 6,
                runSpacing: -8,
                children: [
                  if (item.hasWeight)
                    FilterChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(!item.countWeight ? 'No weight' : 'Weight'),
                      selected: item.countWeight,
                      onSelected: (val) =>
                          onSave?.call(item.copyWith(countWeight: val)),
                    ),
                  if (item.hasDamage)
                    FilterChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(!item.countDamage ? 'No damage' : 'Damage'),
                      selected: item.countDamage,
                      onSelected: (val) =>
                          onSave?.call(item.copyWith(countDamage: val)),
                    ),
                  if (item.hasArmor)
                    FilterChip(
                      visualDensity: VisualDensity.compact,
                      label: Text(!item.countArmor ? 'No armor' : 'Armor'),
                      selected: item.countArmor,
                      onSelected: (val) =>
                          onSave?.call(item.copyWith(countArmor: val)),
                    ),
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(item.equipped ? 'Equipped' : 'Unequiped'),
                    selected: item.equipped,
                    selectedColor: Colors.orange[300],
                    onSelected: (val) =>
                        onSave?.call(item.copyWith(equipped: val)),
                  ),
                ],
              ),
            ),
          mode == InventoryItemCardMode.editable
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            shape: CircleBorder(side: BorderSide.none),
                            child: Text('-'),
                            onPressed: () {
                              final copy = _incrAmount(item, -1);
                              onSave?.call(copy);
                            },
                          ),
                          Text(item.amount.toString()),
                          RaisedButton(
                            shape: CircleBorder(side: BorderSide.none),
                            child: Text('+'),
                            onPressed: () {
                              final copy = _incrAmount(item, 1);
                              onSave?.call(copy);
                            },
                          )
                        ],
                      ),
                    ),
                    CardBottomControls(
                      entityTypeName: 'Inventory Item',
                      onEdit: () => editInventoryItem(context),
                      onDelete: () => deleteCurrentInventoryItem(context),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      child: Text('Add Item'),
                      color: Get.theme.primaryColorLight,
                      onPressed: () {
                        onSave?.call(item);
                        Get.back();
                      },
                    ),
                  ),
                )
        ],
        onExpansionChanged: (value) => analytics.logEvent(
          name: Events.ExpandInventoryItemCard,
          parameters: {'state': value.toString()},
        ),
      ),
    );
  }

  void editInventoryItem(BuildContext context) {
    Get.toNamed(
      '/inventory-item',
      arguments: InventoryItemViewArguments(
        item: item,
        onSave: onSave,
        character: character,
      ),
    );
  }

  void deleteCurrentInventoryItem(BuildContext context) async {
    if (await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
          title: const Text('Delete Inventory Item'),
          text: const Text('Are you sure?'),
          cancelButtonText: Text('Cancel')),
    )) {
      onDelete?.call();
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar(
        'Hmm...',
        "Couldn't launch URL. Is it well-formed?",
        duration: SnackBarDuration.short,
      );
    }
  }

  InventoryItem _incrAmount(InventoryItem item, num amount) => item.copyWith(
        amount: clamp(item.amount + amount, 0, double.infinity).toInt(),
      );
}
