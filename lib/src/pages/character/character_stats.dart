import 'package:dungeon_paper/db/helpers/character_utils.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/src/atoms/card_list_item.dart';
import 'package:dungeon_paper/src/atoms/number_controller.dart';
import 'package:dungeon_paper/src/utils/types.dart';
import 'package:flutter/material.dart';

class CharacterStats extends StatefulWidget {
  final Character character;
  final VoidCallbackDelegate<Character> onUpdate;

  const CharacterStats({
    Key key,
    @required this.character,
    @required this.onUpdate,
  }) : super(key: key);

  @override
  _CharacterStatsState createState() => _CharacterStatsState();
}

class _CharacterStatsState extends State<CharacterStats> {
  int _str;
  int _dex;
  int _con;
  int _int;
  int _wis;
  int _cha;
  Map<CharacterStat, bool> errors = {};

  @override
  void initState() {
    _str = widget.character.strength;
    _dex = widget.character.dexterity;
    _con = widget.character.constitution;
    _int = widget.character.intelligence;
    _wis = widget.character.wisdom;
    _cha = widget.character.charisma;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            for (final stat in ORDERED_STATS)
              EditStatListTile(
                stat: stat,
                value: _stateStatGetter(stat),
                onChange: _valueUpdateBuilder(_setter(stat)),
              ),
          ],
        ),
      ),
    );
  }

  void Function(num) _valueUpdateBuilder(
      CallbackDelegate<num, VoidEmptyCallbackDelegate> setter) {
    return (val) {
      final setterVal = setter(val);
      setState(setterVal);
    };
  }

  CallbackDelegate<num, VoidEmptyCallbackDelegate> _setter(CharacterStat stat) {
    final setter = (int val) {
      final char = widget.character.copyWithStat(stat, val);
      _stateStatSetter(stat, val);
      widget.onUpdate?.call(char);
    };

    return (val) {
      return () {
        if (val == null) {
          errors[stat] = true;
        } else {
          errors[stat] = false;
          setter(val);
        }
      };
    };
  }

  void _stateStatSetter(CharacterStat stat, int val) {
    switch (stat) {
      case CharacterStat.str:
        _str = val;
        break;
      case CharacterStat.dex:
        _dex = val;
        break;
      case CharacterStat.con:
        _con = val;
        break;
      case CharacterStat.int:
        _int = val;
        break;
      case CharacterStat.cha:
        _cha = val;
        break;
      case CharacterStat.wis:
        _wis = val;
        break;
    }
  }

  num _stateStatGetter(CharacterStat stat) {
    switch (stat) {
      case CharacterStat.str:
        return _str;
      case CharacterStat.dex:
        return _dex;
      case CharacterStat.con:
        return _con;
      case CharacterStat.int:
        return _int;
      case CharacterStat.cha:
        return _cha;
      case CharacterStat.wis:
        return _wis;
      default:
        return null;
    }
  }
}

class EditStatListTile extends StatelessWidget {
  final CharacterStat stat;
  final int value;
  final Function(int) onChange;

  const EditStatListTile({
    Key key,
    @required this.stat,
    @required this.value,
    @required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardListItem(
      padding: EdgeInsets.only(left: 8),
      title: Text(CHARACTER_STAT_LABELS[stat]),
      subtitle: Text(
        '${CHARACTER_STAT_MODIFIER_LABELS[stat]}: '
        '${Character.modifierFromValue(value)}',
      ),
      trailing: Container(
        width: 230,
        child: NumberController(
          value: value,
          onChange: onChange,
          min: 0,
          max: MAX_STAT_VALUE,
          autoFocus: false,
        ),
      ),
    );
  }
}
