import 'package:dungeon_paper/src/atoms/flexible_columns.dart';
import 'package:dungeon_paper/src/atoms/search_bar.dart';
import 'package:dungeon_paper/src/molecules/move_card.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:flutter/material.dart';

class ReferenceView extends StatefulWidget {
  const ReferenceView({Key key}) : super(key: key);

  @override
  _ReferenceViewState createState() => _ReferenceViewState();
}

class _ReferenceViewState extends State<ReferenceView> {
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController()..addListener(_searchListener);
  }

  @override
  void dispose() {
    searchController.removeListener(_searchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categories = <String, Iterable<Move>>{
      'Basic Moves': dungeonWorld.basicMoves.where(_isVisible),
      'Special Moves': dungeonWorld.specialMoves.where(_isVisible),
    }..removeWhere((k, v) => v.isEmpty);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28),
          child: FlexibleColumns.builder(
            keyBuilder: (ctx, key, idx) => 'ReferenceView.' + enumName(key),
            items: categories.keys,
            itemCount: (key, idx) => categories[key].length,
            titleBuilder: (ctx, key, idx) => Text(key),
            topSpacerHeight: 38,
            itemBuilder: (ctx, key, idx, catI) {
              final moves = categories[key];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: moves.first is Move
                    ? MoveCard(
                        key: PageStorageKey('$key-$idx'),
                        move: moves.elementAt(idx),
                        onSave: null,
                        onDelete: null,
                        mode: MoveCardMode.fixed,
                      )
                    : Container(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBar(
            controller: searchController,
            hintText: 'Type to search reference',
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
