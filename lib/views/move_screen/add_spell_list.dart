import '../battle_view/spell_card.dart';
import '../../components/categorized_list.dart';
import '../../db/spells.dart';
import '../../utils.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:dungeon_world_data/spell.dart';
import 'package:flutter/material.dart';

class AddSpellList extends StatelessWidget {
  AddSpellList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<Spell>> spells = {};
    dungeonWorld.spells.forEach((spell) {
      spells[spell.level.toString()] ??= [];
      spells[spell.level.toString()].add(spell);
    });

    return CategorizedList.builder(
      categories: spells.keys,
      itemCount: (cat, idx) => spells[cat].length,
      titleBuilder: (ctx, cat, idx) {
        var list = spells[cat];
        return Text(isNumeric(list.first.level)
            ? "Level ${list.first.level}"
            : capitalize(list.first.level));
      },
      itemBuilder: (ctx, cat, idx) {
        var spell = spells[cat][idx];
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: SpellCard(
            index: -1,
            spell: DbSpell.fromSpell(spell),
            mode: SpellCardMode.Addable,
          ),
        );
      },
    );
  }
}
