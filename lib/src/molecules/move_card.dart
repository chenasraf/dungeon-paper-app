import 'package:dungeon_paper/src/atoms/card_bottom_controls.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/scaffolds/move_view.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

enum MoveCardMode { addable, editable, fixed }

class MoveCard extends StatefulWidget {
  final Move move;
  final MoveCardMode mode;
  final bool raceMove;
  final void Function(Move move) onSave;
  final void Function() onDelete;

  const MoveCard({
    Key key,
    @required this.move,
    @required this.onSave,
    @required this.onDelete,
    this.mode = MoveCardMode.fixed,
    this.raceMove = false,
  }) : super(key: key);

  @override
  MoveCardState createState() => MoveCardState();
}

class MoveCardState extends State<MoveCard> {
  @override
  Widget build(BuildContext context) {
    var move = widget.move;
    Widget name = Text("${move.name}${widget.raceMove ? '\'s Move' : ''}");

    var children = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: MarkdownBody(
          data: move.description,
          listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
        ),
      ),
      widget.mode == MoveCardMode.editable
          ? CardBottomControls(
              onEdit: () => Get.toNamed(
                '/edit-move',
                arguments: MoveViewArguments(
                  move: widget.move,
                  onSave: (move) {
                    _save(move);
                    Get.back();
                  },
                ),
              ),
              entityTypeName: 'Move',
              onDelete: () async => await showDialog(
                        context: context,
                        builder: (ctx) => ConfirmationDialog(
                          title: Text('Delete Move?'),
                          okButtonText: Text('Delete Move'),
                        ),
                      ) ==
                      true
                  ? _delete()
                  : null,
            )
          : widget.mode == MoveCardMode.addable
              ? Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      color: Get.theme.primaryColorLight,
                      child: Text('Add Move'),
                      onPressed: () => _save(widget.move),
                    ),
                  ),
                )
              : SizedBox.shrink(),
    ];

    if (widget.move.explanation != null && widget.move.explanation.isNotEmpty) {
      children.insertAll(1, [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Explanation',
              style: Get.theme.textTheme.bodyText1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: MarkdownBody(
            data: move.explanation,
            listItemCrossAxisAlignment:
                MarkdownListItemCrossAxisAlignment.start,
          ),
        ),
      ]);
    }
    Widget expansionTile = ExpansionTile(
      title: widget.raceMove
          ? Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.pets, size: 12.0),
                ),
                Expanded(child: name),
              ],
            )
          : name,
      initiallyExpanded: false,
      children: children,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      onExpansionChanged: (value) => analytics.logEvent(
        name: Events.ExpandMoveCard,
        parameters: {'state': value.toString()},
      ),
    );
    return Card(
      margin: EdgeInsets.zero,
      child: expansionTile,
    );
  }

  void _save(Move move) {
    if (widget.onSave != null) {
      widget.onSave(move);
    }
  }

  void _delete() {
    if (widget.onDelete != null) {
      widget.onDelete();
    }
  }
}
