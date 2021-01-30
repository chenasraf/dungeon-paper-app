import 'package:dungeon_paper/db/models/spell.dart';
import 'package:dungeon_paper/src/atoms/card_bottom_controls.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/lists/tag_list.dart';
import 'package:dungeon_paper/src/scaffolds/spell_view.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

enum SpellCardMode { addable, editable, fixed }

class SpellCard extends StatefulWidget {
  final num index;
  final DbSpell spell;
  final SpellCardMode mode;
  final void Function(DbSpell) onSave;
  final void Function() onDelete;

  const SpellCard({
    Key key,
    @required this.spell,
    @required this.index,
    this.mode,
    @required this.onSave,
    @required this.onDelete,
  }) : super(key: key);

  @override
  SpellCardState createState() => SpellCardState();
}

class SpellCardState extends State<SpellCard> {
  @override
  Widget build(BuildContext context) {
    var spell = widget.spell;
    Widget name = Text(spell.name);

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        key: PageStorageKey(spell.key),
        title: widget.spell.prepared == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  name,
                  Chip(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.lightBlue[100],
                    label: Text('Prepared'),
                    padding: EdgeInsets.all(0),
                    // labelPadding: EdgeInsets.all(0),
                  )
                ],
              )
            : name,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: spell.description,
              listItemCrossAxisAlignment:
                  MarkdownListItemCrossAxisAlignment.start,
            ),
          ),
          if (widget.spell.tags != null && widget.spell.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TagList(tags: widget.spell.tags),
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 6,
              runSpacing: -8,
              children: [
                if (widget.mode == SpellCardMode.editable)
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(spell.prepared ? 'Prepared' : 'Unprepared'),
                    selected: spell.prepared,
                    selectedColor: Colors.lightBlue[100],
                    onSelected: (val) {
                      final copy = spell.copyWith(prepared: val);
                      widget.onSave?.call(copy);
                    },
                  ),
              ],
            ),
          ),
          widget.mode == SpellCardMode.editable
              ? CardBottomControls(
                  onEdit: () => Get.toNamed(
                    '/edit-spell',
                    arguments: SpellViewArguments(
                      spell: widget.spell,
                      onSave: (spell) {
                        widget.onSave?.call(spell);
                        Get.back();
                      },
                    ),
                  ),
                  onDelete: () async {
                    if (await showDialog(
                      context: context,
                      builder: (ctx) => ConfirmationDialog(
                        title: Text('Delete Spell?'),
                        okButtonText: Text('Delete Spell'),
                      ),
                    )) {
                      if (widget.onDelete != null) {
                        widget.onDelete();
                      }
                    }
                  },
                  entityTypeName: 'Spell',
                )
              : widget.mode == SpellCardMode.addable
                  ? Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 10),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: RaisedButton(
                          color: Get.theme.primaryColorLight,
                          child: Text('Add Spell'),
                          onPressed: () {
                            if (widget.onSave != null) {
                              widget.onSave(widget.spell);
                            }
                          },
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
        ],
        onExpansionChanged: (value) => analytics.logEvent(
          name: Events.ExpandSpellCard,
          parameters: {'state': value.toString()},
        ),
      ),
    );
  }

  void togglePrepared(bool state) {}
}
