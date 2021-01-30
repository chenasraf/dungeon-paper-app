import 'package:dungeon_paper/db/models/spell.dart';
import 'package:dungeon_paper/src/atoms/flexible_columns.dart';
import 'package:dungeon_paper/src/atoms/search_bar.dart';
import 'package:dungeon_paper/src/molecules/spell_card.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/spell.dart';
import 'package:flutter/material.dart';

class AddSpellList extends StatefulWidget {
  final void Function(DbSpell) onSave;

  AddSpellList({
    Key key,
    @required this.onSave,
  }) : super(key: key);

  @override
  _AddSpellListState createState() => _AddSpellListState();
}

class _AddSpellListState extends State<AddSpellList> {
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
    final spells = <String, List<Spell>>{};
    dungeonWorld.spells.forEach((spell) {
      if (_isVisible(spell)) {
        spells[spell.level.toString()] ??= [];
        spells[spell.level.toString()].add(spell);
      }
    });

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: FlexibleColumns.builder(
            keyBuilder: null,
            items: spells.keys,
            itemCount: (cat, idx) => spells[cat].length,
            topSpacerHeight: 32,
            titleBuilder: (ctx, cat, idx) {
              final list = spells[cat];
              return Text(
                isNumeric(list.first.level)
                    ? 'Level ${list.first.level}'
                    : capitalize(list.first.level),
              );
            },
            itemBuilder: (ctx, cat, idx, catI) {
              final spell = spells[cat][idx];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: SpellCard(
                  index: -1,
                  spell: DbSpell.fromSpell(spell),
                  mode: SpellCardMode.addable,
                  onSave: widget.onSave,
                  onDelete: null,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 0),
          child: SearchBar(
            controller: searchController,
            hintText: 'Type to search spells',
          ),
        ),
      ],
    );
  }

  bool _isVisible(Spell spell) =>
      searchController.text.isEmpty ||
      _matchStr(spell.name) ||
      _matchStr(spell.description);

  bool _matchStr(String str) => (str ?? '')
      .toLowerCase()
      .contains(searchController.text.toLowerCase().trim());

  void _searchListener() {
    setState(() {});
  }
}
