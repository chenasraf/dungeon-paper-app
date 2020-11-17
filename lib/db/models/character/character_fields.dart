part of './character.dart';

mixin CharacterFields implements FirebaseEntity {
  // Ordered by whichever data needs to come earliest for the rest to be able to calculate
  @override
  FieldsContext fields = FieldsContext([
    //
    // Stats
    IntField(fieldName: 'armor', defaultValue: (ctx) => 0),
    IntField(fieldName: 'str', defaultValue: (ctx) => 8),
    IntField(fieldName: 'dex', defaultValue: (ctx) => 8),
    //
    // con needs to stay above mainClass & maxHP
    IntField(fieldName: 'con', defaultValue: (ctx) => 8),
    IntField(fieldName: 'wis', defaultValue: (ctx) => 8),
    IntField(fieldName: 'int', defaultValue: (ctx) => 8),
    IntField(fieldName: 'cha', defaultValue: (ctx) => 8), // Preferences
    //
    // Class
    PlayerClassListField(
        fieldName: 'playerClasses',
        defaultValue: (ctx) => [dungeonWorld.classes.first]),
    AlignmentNameField(fieldName: 'alignment'),
    IntField(
      fieldName: 'maxHP',
      defaultValue: (ctx) {
        var _mainClassOriginal = dungeonWorld.classes.first;
        var con = 8;
        if (ctx != null) {
          if (ctx['playerClasses'] != null) {
            var classes = ctx.get<List<PlayerClass>>('playerClasses').value;
            if (classes.isNotEmpty) {
              _mainClassOriginal = classes.first;
            }
          }
          if (ctx['con'] != null) {
            con = ctx.get<num>('con').value;
          }
        }
        return _mainClassOriginal.baseHP + con;
      },
    ),

    /// Rest are by no significant order
    StringField(fieldName: 'displayName', defaultValue: (ctx) => 'Traveler'),
    StringField(fieldName: 'photoURL'),
    IntField(fieldName: 'level', defaultValue: (ctx) => 1),
    StringField(fieldName: 'bio'),
    IntField(
      fieldName: 'currentHP',
      defaultValue: (ctx) => ctx?.get<num>('maxHP')?.get ?? 10,
    ),
    IntField(fieldName: 'currentXP'),
    MoveListField(fieldName: 'moves'),
    NoteListField(fieldName: 'notes'),
    SpellListField(fieldName: 'spells'),
    InventoryItemListField(fieldName: 'inventory'),
    DiceField(fieldName: 'hitDice'),
    StringListField(fieldName: 'looks'),
    MoveField(
      fieldName: 'race',
      defaultValue: (ctx) => dungeonWorld.classes.first.raceMoves.first,
    ),
    DecimalField(fieldName: 'coins'),
    IntField(fieldName: 'order'),
    Field<CharacterSettings>(
      fieldName: 'settings',
      defaultValue: (ctx) {
        final raw = ctx?.raw ?? {};
        final _oldUseDefMaxHp = raw['useDefaultMaxHP'] ?? true;
        return CharacterSettings(useDefaultMaxHp: _oldUseDefMaxHp);
      },
      fromJSON: (val, ctx) => CharacterSettings.fromJSON(val),
      toJSON: (val, ctx) => val.toJSON(),
    ),
  ]);

  // Class-Related
  set useDefaultMaxHP(bool value) =>
      settings = settings.copyWith(useDefaultMaxHp: value);
  bool get useDefaultMaxHP => settings.useDefaultMaxHp;

  set alignment(AlignmentName value) =>
      fields.get<AlignmentName>('alignment').set(value);

  List<PlayerClass> get playerClasses =>
      fields.get<List<PlayerClass>>('playerClasses').value;
  set playerClasses(List<PlayerClass> value) =>
      fields.get<List<PlayerClass>>('playerClasses').set(value);
  PlayerClass get mainClass => playerClasses != null && playerClasses.isNotEmpty
      ? playerClasses.first
      : null;
  set mainClass(PlayerClass value) =>
      playerClasses = [value, ...playerClasses.skip(1)].toList();
  Dice get damageDice => fields.get<Dice>('hitDice').value;
  set damageDice(Dice value) => fields.get<Dice>('hitDice').set(value);
  AlignmentName get alignment => fields.get<AlignmentName>('alignment').value;
  num get level => fields.get<num>('level').value;
  set level(num value) => fields.get<num>('level').set(value);
  num get _currentHP => fields.get<num>('currentHP').value;
  num get currentHP => min(_currentHP, maxHP);
  set currentHP(num value) => fields.get<num>('currentHP').set(value);
  num get currentXP => fields.get<num>('currentXP').value;
  set currentXP(num value) => fields.get<num>('currentXP').set(value);
  num get _maxHP => fields.get<num>('maxHP').value;
  set _maxHP(num value) => fields.get<num>('maxHP').set(value);
  num get maxHP => useDefaultMaxHP == true ? defaultMaxHP : _maxHP;
  num get defaultMaxHP => (mainClass?.baseHP ?? 0) + con;

  num get strMod => modifierFromValue(str);
  num get dexMod => modifierFromValue(dex);
  num get conMod => modifierFromValue(con);
  num get wisMod => modifierFromValue(wis);
  num get intMod => modifierFromValue(int);
  num get chaMod => modifierFromValue(cha);

  set maxHP(value) {
    _maxHP = value;
    if (currentHP > _maxHP) currentHP = value;
  }

  // Stats
  num get str => fields.get<num>('str').value;
  set str(num value) => fields.get<num>('str').set(value);
  num get dex => fields.get<num>('dex').value;
  set dex(num value) => fields.get<num>('dex').set(value);
  num get con => fields.get<num>('con').value;
  set con(num value) => fields.get<num>('con').set(value);
  num get wis => fields.get<num>('wis').value;
  set wis(num value) => fields.get<num>('wis').set(value);
  num get int => fields.get<num>('int').value;
  set int(num value) => fields.get<num>('int').set(value);
  num get cha => fields.get<num>('cha').value;
  set cha(num value) => fields.get<num>('cha').set(value);
  num get armor => settings.autoCalcArmor ? equippedArmor : rawArmor;
  set armor(num value) => fields.get<num>('armor').set(value);
  num get rawArmor => fields.get<num>('armor').value;

  // Main Item Types
  List<Move> get moves => fields.get<List<Move>>('moves').value;
  set moves(List<Move> value) => fields.get<List<Move>>('moves').set(value);
  List<Note> get notes => fields.get<List<Note>>('notes').value;
  set notes(List<Note> value) => fields.get<List<Note>>('notes').set(value);
  List<DbSpell> get spells => fields.get<List<DbSpell>>('spells').value;
  set spells(List<DbSpell> value) =>
      fields.get<List<DbSpell>>('spells').set(value);
  List<InventoryItem> get inventory =>
      fields.get<List<InventoryItem>>('inventory').value;
  set inventory(List<InventoryItem> value) =>
      fields.get<List<InventoryItem>>('inventory').set(value);

  // Bio
  String get displayName => fields.get<String>('displayName').value;
  set displayName(String value) => fields.get<String>('displayName').set(value);
  String get photoURL => fields.get<String>('photoURL').value;
  set photoURL(String value) => fields.get<String>('photoURL').set(value);
  String get bio => fields.get<String>('bio').value;
  set bio(String value) => fields.get<String>('bio').set(value);
  List<String> get looks => fields.get<List<String>>('looks').value;
  set looks(List<String> value) => fields.get<List<String>>('looks').set(value);
  Move get race => fields.get<Move>('race').value;
  set race(Move value) => fields.get<Move>('race').set(value);
  num get coins => fields.get<num>('coins').value;
  set coins(num value) => fields.get<num>('coins').set(value);
  num get order => fields.get<num>('order').value;
  set order(num value) => fields.get<num>('order').set(value);
  core.int get maxLoad => mainClass.load + strMod;
  CharacterSettings get settings =>
      fields.get<CharacterSettings>('settings').value;

  set settings(CharacterSettings value) =>
      fields.get<CharacterSettings>('settings').set(value);

  num statValueFromKey(CharacterKey key) {
    final _key = enumName(key).toLowerCase();
    switch (_key) {
      case 'int':
        return int;
      case 'dex':
        return dex;
      case 'wis':
        return wis;
      case 'cha':
        return cha;
      case 'str':
        return str;
      case 'con':
        return con;
      default:
        throw Exception('Bad modifier provided: $key');
    }
  }

  num modifierFromKey(CharacterKey key) {
    final _key = enumName(key).toLowerCase();
    switch (_key) {
      case 'int':
        return modifierFromValue(int);
      case 'dex':
        return modifierFromValue(dex);
      case 'wis':
        return modifierFromValue(wis);
      case 'cha':
        return modifierFromValue(cha);
      case 'str':
        return modifierFromValue(str);
      case 'con':
        return modifierFromValue(con);
      default:
        throw Exception('Bad modifier provided: $key');
    }
  }

  CharacterKey modifierKey(String modifierName) =>
      CharacterKey.values.firstWhere(
        (v) => enumName(v) == modifierName,
        orElse: () => null,
      );

  static num modifierFromValue(num stat) {
    const modifiers = {1: -3, 4: -2, 6: -1, 9: 0, 13: 1, 16: 2, 18: 3};

    if (modifiers.containsKey(stat)) {
      return modifiers[stat];
    }

    for (var i = stat; i > 0; --i) {
      if (modifiers.containsKey(i)) {
        return modifiers[i];
      }
    }

    return -1;
  }

  num get load {
    var count = 0.0;
    inventory.forEach((item) {
      final wght = item.tags?.firstWhere(
          (t) => t?.name?.toLowerCase() == 'weight',
          orElse: () => null);
      if (wght != null && wght.hasValue) {
        num wghtValue = 0;
        if (wght.value is num) {
          wghtValue += wght.value;
        } else {
          wghtValue += double.tryParse(wght.value ?? 0) ?? 0.0;
        }
        count += wghtValue * item.amount;
      }
    });
    return count;
  }

  num get equippedArmor {
    var count = 0;
    inventory.forEach((item) {
      if (!item.equipped) {
        return 0;
      }
      final armor = item.tags?.firstWhere(
          (t) => t?.name?.toLowerCase() == 'armor',
          orElse: () => null);
      if (armor != null && armor.hasValue) {
        num armorValue = 0;
        if (armor.value is num) {
          armorValue += armor.value;
        } else {
          armorValue += core.int.tryParse(armor.value ?? 0) ?? 0;
        }
        count += armorValue * item.amount;
      }
    });
    return count;
  }

  num get equippedDamage {
    var count = 0;
    inventory.forEach((item) {
      if (!item.equipped) {
        return 0;
      }
      final damage = item.tags?.firstWhere(
          (t) => t?.name?.toLowerCase() == 'damage',
          orElse: () => null);
      if (damage != null && damage.hasValue) {
        num armorValue = 0;
        if (damage.value is num) {
          armorValue += damage.value;
        } else {
          armorValue += core.int.tryParse(damage.value ?? 0) ?? 0;
        }
        count += armorValue * item.amount;
      }
    });
    return count;
  }
}