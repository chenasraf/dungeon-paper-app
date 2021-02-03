import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/move.dart';
import 'package:dungeon_paper/db/models/spell.dart';
import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/atoms/flexible_columns.dart';
import 'package:dungeon_paper/src/atoms/empty_state.dart';
import 'package:dungeon_paper/src/atoms/roll_button_with_edit.dart';
import 'package:dungeon_paper/src/atoms/search_bar.dart';
import 'package:dungeon_paper/src/dialogs/roll_dice_view.dart';
import 'package:dungeon_paper/src/flutter_utils/dice_controller.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/molecules/dice_roll_box.dart';
import 'package:dungeon_paper/src/molecules/move_card.dart';
import 'package:dungeon_paper/src/molecules/spell_card.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:dungeon_world_data/move.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum CategoryKeys {
  StartingMoves,
  AdvancedMoves,
  Spells,
  EmptyState,
  Dice,
}

class BattleView extends StatefulWidget {
  static final _CATEGORY_LABELS = {
    CategoryKeys.StartingMoves: 'Starting Moves',
    CategoryKeys.AdvancedMoves: 'Advanced Moves',
    CategoryKeys.Spells: 'Spells',
  };

  final Character character;

  const BattleView({
    Key key,
    @required this.character,
  }) : super(key: key);

  @override
  _BattleViewState createState() => _BattleViewState();
}

class _BattleViewState extends State<BattleView> {
  DiceListController diceListController;
  String rollSession;
  TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController()..addListener(_searchListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: FlexibleColumns.builder(
            keyBuilder: (ctx, key, idx) => 'BattleView.' + enumName(key),
            items: filtered.keys,
            itemCount: (key, idx) => filtered[key].length,
            bottomSpacerHeight: BOTTOM_SPACER.height,
            topSpacerHeight: 50,
            titleBuilder: (ctx, key, idx) =>
                BattleView._CATEGORY_LABELS.containsKey(key)
                    ? Text(BattleView._CATEGORY_LABELS[key])
                    : null,
            itemBuilder: (ctx, key, idx, catIdx) {
              var moves = filtered[key];
              return buildItem(moves, idx, key);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBar(
            controller: searchController,
            hintText: 'Type to search moves or spells',
          ),
        ),
      ],
    );
  }

  Widget buildItem(List moves, int idx, CategoryKeys key) {
    if (key == CategoryKeys.Dice) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RollButtonWithEdit(
                    character: widget.character,
                    diceList: [Dice.d6 * 2],
                    onRoll: _onRoll(Dice.d6 * 2),
                    label: Text('Roll Action'),
                    analyticsSource: 'Battle - Roll Action',
                    brightness: Brightness.light,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: RollButtonWithEdit(
                    character: widget.character,
                    diceList: [
                      widget.character.damageDice
                          .copyWith(modifier: widget.character.equippedDamage)
                    ],
                    onRoll: _onRoll(
                      widget.character.damageDice
                          .copyWith(modifier: widget.character.equippedDamage),
                    ),
                    label: Text('Roll Damage'),
                    analyticsSource: 'Battle - Roll Danmage',
                    brightness: Brightness.light,
                  ),
                ),
              ],
            ),
          ),
          if (diceListController != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DiceRollBox(
                analyticsSource: Routes.battle.analyticsName,
                key: Key(rollSession),
                controller: diceListController,
                animated: true,
                onRemove: _removeRoll,
                onEdit: _editRoll,
              ),
            ),
        ],
      );
    }
    if (key == CategoryKeys.EmptyState) {
      return Padding(
        padding: EdgeInsets.only(top: 30),
        child: EmptyState(
          assetName: 'swords.svg',
          title: Text('You have no learned skills'),
          subtitle: Text(
              "Use the '+' button to add a move or spell and start building your list."),
        ),
      );
    }
    return moves?.isNotEmpty == true
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: moves[idx] is Move
                ? MoveCard(
                    key: PageStorageKey(moves[idx].key ?? moves[idx].name),
                    move: moves[idx],
                    mode: key == CategoryKeys.StartingMoves
                        ? MoveCardMode.fixed
                        : MoveCardMode.editable,
                    raceMove: key == CategoryKeys.StartingMoves && idx == 0,
                    onSave: (move) => updateMove(widget.character, move),
                    onDelete: () => deleteMove(widget.character, moves[idx]),
                  )
                : SpellCard(
                    index: idx,
                    spell: moves[idx],
                    mode: SpellCardMode.editable,
                    onSave: (spell) => updateSpell(widget.character, spell),
                    onDelete: () => deleteSpell(widget.character, moves[idx]),
                  ),
          )
        : Container();
  }

  Map<CategoryKeys, List<dynamic>> get categories => {
        CategoryKeys.Dice: [null],
        CategoryKeys.StartingMoves:
            [widget.character.race] + widget.character.mainClass.startingMoves,
        CategoryKeys.AdvancedMoves: widget.character.moves,
        CategoryKeys.Spells: widget.character.spells,
        if (widget.character.moves.isEmpty && widget.character.spells.isEmpty)
          CategoryKeys.EmptyState: [null],
      };

  Map<CategoryKeys, List<dynamic>> get filtered => Map.from(
        categories.map(
          (key, value) => [CategoryKeys.Dice, CategoryKeys.EmptyState]
                  .contains(key)
              ? MapEntry(key, value)
              : MapEntry(
                  key,
                  value
                      .where((v) =>
                          v is Move ? _isMoveVisible(v) : _isSpellVisible(v))
                      .toList()),
        ),
      );

  void Function() _onRoll(Dice dice) {
    return () {
      setState(() {
        rollSession = Uuid().v4();
        diceListController = DiceListController([dice]);
      });
    };
  }

  void _removeRoll() {
    setState(() {
      rollSession = Uuid().v4();
      diceListController = null;
    });
  }

  void _editRoll() {
    showDiceRollView(
      character: widget.character,
      initialAddingDice: diceListController.value,
      analyticsSource: Routes.battle.analyticsName,
    );
  }

  void _searchListener() {
    setState(() {});
  }

  bool _isMoveVisible(Move move) =>
      move != null &&
      (searchController.text.isEmpty ||
          _matchStr(move.name) ||
          _matchStr(move.description) ||
          _matchStr(move.explanation));

  bool _isSpellVisible(DbSpell spell) =>
      spell != null &&
      (searchController.text.isEmpty ||
          _matchStr(spell.name) ||
          _matchStr(spell.description) ||
          _matchStr(spell.tags.map((t) => t.toJSON().toString()).join(', ')));

  bool _matchStr(String str) => (str ?? '')
      .toLowerCase()
      .contains(searchController.text.toLowerCase().trim());
}
