import '../../components/number_controller.dart';
import '../../db/character.dart';
import '../../db/character_utils.dart';
import '../../components/dialogs.dart';
import '../../flutter_utils.dart';
import 'package:flutter/material.dart';
import '../edit_character/character_wizard_utils.dart';

class EditStats extends StatefulWidget {
  final DbCharacter character;
  final CharSaveFunction onSave;
  final ScaffoldBuilderFunction builder;

  const EditStats({
    Key key,
    @required this.character,
    @required this.onSave,
    this.builder,
  }) : super(key: key);

  EditStats.withScaffold({
    Key key,
    @required this.character,
    @required this.onSave,
    Function() onDidPop,
    Function() onWillPop,
    bool shouldPreventPop = true,
  })  : builder = characterWizardScaffold(
          titleText: 'Stats',
          onDidPop: onDidPop,
          onWillPop: onWillPop,
          shouldPreventPop: shouldPreventPop,
          buttonType: WizardScaffoldButtonType.back,
          mode: DialogMode.Create,
        ),
        super(key: key);

  @override
  _EditStatsState createState() => _EditStatsState();
}

class _EditStatsState extends State<EditStats> {
  int _str;
  int _dex;
  int _con;
  int _int;
  int _wis;
  int _cha;
  Map<CharacterKeys, bool> errors = {};

  @override
  void initState() {
    _str = widget.character.str;
    _dex = widget.character.dex;
    _con = widget.character.con;
    _int = widget.character.int;
    _wis = widget.character.wis;
    _cha = widget.character.cha;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var child = Column(
      children: <Widget>[
        for (CharacterKeys stat in ORDERED_STATS)
          EditStatListTile(
            stat: stat,
            value: _getter(stat),
            onChange: _valueUpdateBuilder(_setter(stat)),
          ),
      ],
    );
    if (widget.builder != null) {
      return widget.builder(
        context: context,
        child: child,
        save: _save,
        isValid: _isFormValid,
      );
    }
    return child;
  }

  void Function(num) _valueUpdateBuilder(
      CallbackFunc<num, VoidEmptyCallbackFunc> setter) {
    return (val) {
      final setterVal = setter(val);
      setState(setterVal);
    };
  }

  CallbackFunc<num, VoidEmptyCallbackFunc> _setter(CharacterKeys stat) {
    Function(num) setter;
    Function(bool) errorSetter;
    switch (stat) {
      case (CharacterKeys.str):
        setter = (val) {
          _str = val;
        };
        errorSetter = (state) {
          errors[CharacterKeys.str] = state;
        };
        break;
      case (CharacterKeys.dex):
        setter = (val) {
          _dex = val;
        };
        errorSetter = (state) {
          errors[CharacterKeys.dex] = state;
        };
        break;
      case (CharacterKeys.con):
        setter = (val) {
          _con = val;
        };
        errorSetter = (state) {
          errors[CharacterKeys.con] = state;
        };
        break;
      case (CharacterKeys.int):
        setter = (val) {
          _int = val;
        };
        errorSetter = (state) {
          errors[CharacterKeys.int] = state;
        };
        break;
      case (CharacterKeys.cha):
        setter = (val) {
          _cha = val;
        };
        errorSetter = (state) {
          errors[CharacterKeys.cha] = state;
        };
        break;
      case (CharacterKeys.wis):
        setter = (val) {
          _wis = val;
        };
        errorSetter = (state) {
          errors[CharacterKeys.wis] = state;
        };
        break;
      default:
        setter = (val) {};
    }

    return (val) {
      return () {
        if (val == null) {
          errorSetter(true);
        } else {
          errorSetter(false);
          setter(val);
        }
      };
    };
  }

  num _getter(CharacterKeys stat) {
    switch (stat) {
      case (CharacterKeys.str):
        return _str;
      case (CharacterKeys.dex):
        return _dex;
      case (CharacterKeys.con):
        return _con;
      case (CharacterKeys.int):
        return _int;
      case (CharacterKeys.cha):
        return _cha;
      case (CharacterKeys.wis):
        return _wis;
      default:
        return null;
    }
  }

  _save() {
    final DbCharacter character = widget.character;
    final List<CharacterKeys> keys = ORDERED_STATS;

    character.str = _str;
    character.dex = _dex;
    character.cha = _cha;
    character.wis = _wis;
    character.int = _int;
    character.con = _con;

    if (widget.onSave != null) {
      widget.onSave(character, keys);
    }
  }

  bool _isFormValid() {
    return !errors.values.any((s) => s) &&
        [_str, _dex, _cha, _wis, _int, _con]
            .every((s) => s >= 0 && s <= MAX_STAT_VALUE);
  }
}

class EditStatListTile extends StatelessWidget {
  final CharacterKeys stat;
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 1.0,
        type: MaterialType.card,
        child: ListTile(
          title: Text(
            CHARACTER_STAT_LABELS[stat],
            textScaleFactor: 1.2,
          ),
          subtitle: Text(
            "${CHARACTER_STAT_MODIFIER_LABELS[stat]}: " +
                "${DbCharacter.statModifier(value)}",
          ),
          trailing: Container(
            width: 230,
            child: NumberController(
              value: value,
              onChange: onChange,
              min: 0,
              max: MAX_STAT_VALUE,
            ),
          ),
        ),
      ),
    );
  }
}