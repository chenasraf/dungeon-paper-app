import 'package:dungeon_paper/src/atoms/flexible_columns.dart';
import 'package:dungeon_paper/src/atoms/search_bar.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/lists/player_class_list.dart';
import 'package:dungeon_paper/src/molecules/move_card.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMoveList extends StatefulWidget {
  final PlayerClass playerClass;
  final void Function(Move move) onSave;

  AddMoveList({
    Key key,
    this.playerClass,
    @required this.onSave,
  });

  @override
  _AddMoveListState createState() => _AddMoveListState();
}

class _AddMoveListState extends State<AddMoveList> {
  PlayerClass currentCls;
  TextEditingController searchController;

  @override
  void dispose() {
    searchController.removeListener(_searchListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentCls = widget.playerClass ?? dungeonWorld.classes.elementAt(0);
    searchController = TextEditingController()..addListener(_searchListener);
  }

  @override
  Widget build(BuildContext context) {
    var moves = <int, Iterable<Move>>{
      0: currentCls.startingMoves.where(_isVisible),
      2: currentCls.advancedMoves1.where(_isVisible),
      6: currentCls.advancedMoves2.where(_isVisible)
    };
    const LEADING_KEY = '';

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: FlexibleColumns.builder(
            keyBuilder: null,
            topSpacerHeight: 48,
            items: [LEADING_KEY] + moves.keys.map((k) => k.toString()).toList(),
            titleBuilder: (ctx, String minLevel, idx) {
              if (minLevel == LEADING_KEY) {
                return null;
              }

              var maxLevel = moves.keys.firstWhere(
                      (curLevel) => curLevel > int.tryParse(minLevel),
                      orElse: () => 11) -
                  1;

              return minLevel == '0'
                  ? Text('Starting Moves')
                  : Text('Levels $minLevel-${maxLevel}');
            },
            itemBuilder: (ctx, key, idx, catI) {
              if (key == LEADING_KEY) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Moves from class:',
                        style: TextStyle(
                          color: Get.theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                    Expanded(
                      child: PlayerClassList.dropdown(
                        value: currentCls,
                        onChanged: (cls) {
                          setState(() {
                            currentCls = cls;
                          });
                        },
                      ),
                    )
                  ],
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: MoveCard(
                  move: moves[int.parse(key)].elementAt(idx),
                  mode: MoveCardMode.addable,
                  onSave: widget.onSave,
                  onDelete: null,
                ),
              );
            },
            itemCount: (key, idx) =>
                key != LEADING_KEY ? moves[int.parse(key)].length : 1,
            bottomSpacerHeight: BOTTOM_SPACER.height,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 0),
          child: SearchBar(
            controller: searchController,
            hintText: 'Type to search moves',
          ),
        ),
      ],
    );
  }

  bool _isVisible(Move move) =>
      searchController.text.isEmpty ||
      _matchStr(move.name) ||
      _matchStr(move.description) ||
      _matchStr(move.explanation);

  bool _matchStr(String str) => (str ?? '')
      .toLowerCase()
      .contains(searchController.text.toLowerCase().trim());

  void _searchListener() {
    setState(() {});
  }
}
