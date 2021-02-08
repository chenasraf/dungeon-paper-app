// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Character _$CharacterFromJson(Map<String, dynamic> json) {
  return _Character.fromJson(json);
}

/// @nodoc
class _$CharacterTearOff {
  const _$CharacterTearOff();

// ignore: unused_element
  _Character call(
      {@required
      @DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @JsonKey(defaultValue: 'Traveler')
          String displayName = 'Traveler',
      @JsonKey(defaultValue: '')
          String photoURL = '',
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(name: 'armor', defaultValue: 0)
          int baseArmor = 0,
      @JsonKey(name: 'str', defaultValue: 8)
          int strength = 8,
      @JsonKey(name: 'dex', defaultValue: 8)
          int dexterity = 8,
      @JsonKey(name: 'con', defaultValue: 8)
          int constitution = 8,
      @JsonKey(name: 'wis', defaultValue: 8)
          int wisdom = 8,
      @JsonKey(name: 'int', defaultValue: 8)
          int intelligence = 8,
      @JsonKey(name: 'cha', defaultValue: 0)
          int charisma = 0,
      @required
      @PlayerClassConverter()
          PlayerClass playerClass,
      @JsonKey(defaultValue: AlignmentName.neutral)
          AlignmentName alignment = AlignmentName.neutral,
      @JsonKey(name: 'maxHP')
          int customMaxHP,
      @JsonKey(defaultValue: 1)
          int level = 1,
      String bio = '',
      @JsonKey(name: 'currentHP', defaultValue: 100)
          int customCurrentHP = 100,
      @JsonKey(defaultValue: 0)
          int currentXP = 0,
      @DWMoveConverter()
      @JsonKey(defaultValue: const [])
          List<Move> moves = const [],
      @NoteConverter()
      @JsonKey(defaultValue: const [])
          List<Note> notes = const [],
      @SpellConverter()
      @JsonKey(defaultValue: const [])
          List<DbSpell> spells = const [],
      @InventoryItemConverter()
      @JsonKey(defaultValue: const [])
          List<InventoryItem> inventory = const [],
      @DiceConverter()
      @JsonKey(name: 'hitDice')
          Dice customDamageDice,
      @JsonKey(defaultValue: const [])
          List<String> looks = const [],
      @DWMoveConverter()
      @JsonKey(name: 'race')
          Move raceMove,
      @JsonKey(defaultValue: 0)
          double coins = 0,
      @JsonKey(defaultValue: 0)
          int order = 0,
      @JsonKey(name: 'settings')
      @CharacterSettingsConverter()
          CharacterSettings customSettings}) {
    return _Character(
      key: key,
      ref: ref,
      displayName: displayName,
      photoURL: photoURL,
      createdAt: createdAt,
      updatedAt: updatedAt,
      baseArmor: baseArmor,
      strength: strength,
      dexterity: dexterity,
      constitution: constitution,
      wisdom: wisdom,
      intelligence: intelligence,
      charisma: charisma,
      playerClass: playerClass,
      alignment: alignment,
      customMaxHP: customMaxHP,
      level: level,
      bio: bio,
      customCurrentHP: customCurrentHP,
      currentXP: currentXP,
      moves: moves,
      notes: notes,
      spells: spells,
      inventory: inventory,
      customDamageDice: customDamageDice,
      looks: looks,
      raceMove: raceMove,
      coins: coins,
      order: order,
      customSettings: customSettings,
    );
  }

// ignore: unused_element
  Character fromJson(Map<String, Object> json) {
    return Character.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Character = _$CharacterTearOff();

/// @nodoc
mixin _$Character {
  @DefaultUuid()
  String get key;
  @DocumentReferenceConverter()
  DocumentReference get ref;
  @JsonKey(defaultValue: 'Traveler')
  String get displayName;
  @JsonKey(defaultValue: '')
  String get photoURL;
  @DateTimeConverter()
  DateTime get createdAt;
  @DateTimeConverter()
  DateTime get updatedAt;
  @JsonKey(name: 'armor', defaultValue: 0)
  int get baseArmor;
  @JsonKey(name: 'str', defaultValue: 8)
  int get strength;
  @JsonKey(name: 'dex', defaultValue: 8)
  int get dexterity;
  @JsonKey(name: 'con', defaultValue: 8)
  int get constitution;
  @JsonKey(name: 'wis', defaultValue: 8)
  int get wisdom;
  @JsonKey(name: 'int', defaultValue: 8)
  int get intelligence;
  @JsonKey(name: 'cha', defaultValue: 0)
  int get charisma;
  @PlayerClassConverter()
  PlayerClass get playerClass;
  @JsonKey(defaultValue: AlignmentName.neutral)
  AlignmentName get alignment;
  @JsonKey(name: 'maxHP')
  int get customMaxHP;
  @JsonKey(defaultValue: 1)
  int get level;
  String get bio;
  @JsonKey(name: 'currentHP', defaultValue: 100)
  int get customCurrentHP;
  @JsonKey(defaultValue: 0)
  int get currentXP;
  @DWMoveConverter()
  @JsonKey(defaultValue: const [])
  List<Move> get moves;
  @NoteConverter()
  @JsonKey(defaultValue: const [])
  List<Note> get notes;
  @SpellConverter()
  @JsonKey(defaultValue: const [])
  List<DbSpell> get spells;
  @InventoryItemConverter()
  @JsonKey(defaultValue: const [])
  List<InventoryItem> get inventory;
  @DiceConverter()
  @JsonKey(name: 'hitDice')
  Dice get customDamageDice;
  @JsonKey(defaultValue: const [])
  List<String> get looks;
  @DWMoveConverter()
  @JsonKey(name: 'race')
  Move get raceMove;
  @JsonKey(defaultValue: 0)
  double get coins;
  @JsonKey(defaultValue: 0)
  int get order;
  @JsonKey(name: 'settings')
  @CharacterSettingsConverter()
  CharacterSettings get customSettings;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $CharacterCopyWith<Character> get copyWith;
}

/// @nodoc
abstract class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) then) =
      _$CharacterCopyWithImpl<$Res>;
  $Res call(
      {@DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @JsonKey(defaultValue: 'Traveler')
          String displayName,
      @JsonKey(defaultValue: '')
          String photoURL,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(name: 'armor', defaultValue: 0)
          int baseArmor,
      @JsonKey(name: 'str', defaultValue: 8)
          int strength,
      @JsonKey(name: 'dex', defaultValue: 8)
          int dexterity,
      @JsonKey(name: 'con', defaultValue: 8)
          int constitution,
      @JsonKey(name: 'wis', defaultValue: 8)
          int wisdom,
      @JsonKey(name: 'int', defaultValue: 8)
          int intelligence,
      @JsonKey(name: 'cha', defaultValue: 0)
          int charisma,
      @PlayerClassConverter()
          PlayerClass playerClass,
      @JsonKey(defaultValue: AlignmentName.neutral)
          AlignmentName alignment,
      @JsonKey(name: 'maxHP')
          int customMaxHP,
      @JsonKey(defaultValue: 1)
          int level,
      String bio,
      @JsonKey(name: 'currentHP', defaultValue: 100)
          int customCurrentHP,
      @JsonKey(defaultValue: 0)
          int currentXP,
      @DWMoveConverter()
      @JsonKey(defaultValue: const [])
          List<Move> moves,
      @NoteConverter()
      @JsonKey(defaultValue: const [])
          List<Note> notes,
      @SpellConverter()
      @JsonKey(defaultValue: const [])
          List<DbSpell> spells,
      @InventoryItemConverter()
      @JsonKey(defaultValue: const [])
          List<InventoryItem> inventory,
      @DiceConverter()
      @JsonKey(name: 'hitDice')
          Dice customDamageDice,
      @JsonKey(defaultValue: const [])
          List<String> looks,
      @DWMoveConverter()
      @JsonKey(name: 'race')
          Move raceMove,
      @JsonKey(defaultValue: 0)
          double coins,
      @JsonKey(defaultValue: 0)
          int order,
      @JsonKey(name: 'settings')
      @CharacterSettingsConverter()
          CharacterSettings customSettings});

  $CharacterSettingsCopyWith<$Res> get customSettings;
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res> implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._value, this._then);

  final Character _value;
  // ignore: unused_field
  final $Res Function(Character) _then;

  @override
  $Res call({
    Object key = freezed,
    Object ref = freezed,
    Object displayName = freezed,
    Object photoURL = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object baseArmor = freezed,
    Object strength = freezed,
    Object dexterity = freezed,
    Object constitution = freezed,
    Object wisdom = freezed,
    Object intelligence = freezed,
    Object charisma = freezed,
    Object playerClass = freezed,
    Object alignment = freezed,
    Object customMaxHP = freezed,
    Object level = freezed,
    Object bio = freezed,
    Object customCurrentHP = freezed,
    Object currentXP = freezed,
    Object moves = freezed,
    Object notes = freezed,
    Object spells = freezed,
    Object inventory = freezed,
    Object customDamageDice = freezed,
    Object looks = freezed,
    Object raceMove = freezed,
    Object coins = freezed,
    Object order = freezed,
    Object customSettings = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed ? _value.key : key as String,
      ref: ref == freezed ? _value.ref : ref as DocumentReference,
      displayName:
          displayName == freezed ? _value.displayName : displayName as String,
      photoURL: photoURL == freezed ? _value.photoURL : photoURL as String,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      baseArmor: baseArmor == freezed ? _value.baseArmor : baseArmor as int,
      strength: strength == freezed ? _value.strength : strength as int,
      dexterity: dexterity == freezed ? _value.dexterity : dexterity as int,
      constitution:
          constitution == freezed ? _value.constitution : constitution as int,
      wisdom: wisdom == freezed ? _value.wisdom : wisdom as int,
      intelligence:
          intelligence == freezed ? _value.intelligence : intelligence as int,
      charisma: charisma == freezed ? _value.charisma : charisma as int,
      playerClass: playerClass == freezed
          ? _value.playerClass
          : playerClass as PlayerClass,
      alignment:
          alignment == freezed ? _value.alignment : alignment as AlignmentName,
      customMaxHP:
          customMaxHP == freezed ? _value.customMaxHP : customMaxHP as int,
      level: level == freezed ? _value.level : level as int,
      bio: bio == freezed ? _value.bio : bio as String,
      customCurrentHP: customCurrentHP == freezed
          ? _value.customCurrentHP
          : customCurrentHP as int,
      currentXP: currentXP == freezed ? _value.currentXP : currentXP as int,
      moves: moves == freezed ? _value.moves : moves as List<Move>,
      notes: notes == freezed ? _value.notes : notes as List<Note>,
      spells: spells == freezed ? _value.spells : spells as List<DbSpell>,
      inventory: inventory == freezed
          ? _value.inventory
          : inventory as List<InventoryItem>,
      customDamageDice: customDamageDice == freezed
          ? _value.customDamageDice
          : customDamageDice as Dice,
      looks: looks == freezed ? _value.looks : looks as List<String>,
      raceMove: raceMove == freezed ? _value.raceMove : raceMove as Move,
      coins: coins == freezed ? _value.coins : coins as double,
      order: order == freezed ? _value.order : order as int,
      customSettings: customSettings == freezed
          ? _value.customSettings
          : customSettings as CharacterSettings,
    ));
  }

  @override
  $CharacterSettingsCopyWith<$Res> get customSettings {
    if (_value.customSettings == null) {
      return null;
    }
    return $CharacterSettingsCopyWith<$Res>(_value.customSettings, (value) {
      return _then(_value.copyWith(customSettings: value));
    });
  }
}

/// @nodoc
abstract class _$CharacterCopyWith<$Res> implements $CharacterCopyWith<$Res> {
  factory _$CharacterCopyWith(
          _Character value, $Res Function(_Character) then) =
      __$CharacterCopyWithImpl<$Res>;
  @override
  $Res call(
      {@DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @JsonKey(defaultValue: 'Traveler')
          String displayName,
      @JsonKey(defaultValue: '')
          String photoURL,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(name: 'armor', defaultValue: 0)
          int baseArmor,
      @JsonKey(name: 'str', defaultValue: 8)
          int strength,
      @JsonKey(name: 'dex', defaultValue: 8)
          int dexterity,
      @JsonKey(name: 'con', defaultValue: 8)
          int constitution,
      @JsonKey(name: 'wis', defaultValue: 8)
          int wisdom,
      @JsonKey(name: 'int', defaultValue: 8)
          int intelligence,
      @JsonKey(name: 'cha', defaultValue: 0)
          int charisma,
      @PlayerClassConverter()
          PlayerClass playerClass,
      @JsonKey(defaultValue: AlignmentName.neutral)
          AlignmentName alignment,
      @JsonKey(name: 'maxHP')
          int customMaxHP,
      @JsonKey(defaultValue: 1)
          int level,
      String bio,
      @JsonKey(name: 'currentHP', defaultValue: 100)
          int customCurrentHP,
      @JsonKey(defaultValue: 0)
          int currentXP,
      @DWMoveConverter()
      @JsonKey(defaultValue: const [])
          List<Move> moves,
      @NoteConverter()
      @JsonKey(defaultValue: const [])
          List<Note> notes,
      @SpellConverter()
      @JsonKey(defaultValue: const [])
          List<DbSpell> spells,
      @InventoryItemConverter()
      @JsonKey(defaultValue: const [])
          List<InventoryItem> inventory,
      @DiceConverter()
      @JsonKey(name: 'hitDice')
          Dice customDamageDice,
      @JsonKey(defaultValue: const [])
          List<String> looks,
      @DWMoveConverter()
      @JsonKey(name: 'race')
          Move raceMove,
      @JsonKey(defaultValue: 0)
          double coins,
      @JsonKey(defaultValue: 0)
          int order,
      @JsonKey(name: 'settings')
      @CharacterSettingsConverter()
          CharacterSettings customSettings});

  @override
  $CharacterSettingsCopyWith<$Res> get customSettings;
}

/// @nodoc
class __$CharacterCopyWithImpl<$Res> extends _$CharacterCopyWithImpl<$Res>
    implements _$CharacterCopyWith<$Res> {
  __$CharacterCopyWithImpl(_Character _value, $Res Function(_Character) _then)
      : super(_value, (v) => _then(v as _Character));

  @override
  _Character get _value => super._value as _Character;

  @override
  $Res call({
    Object key = freezed,
    Object ref = freezed,
    Object displayName = freezed,
    Object photoURL = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object baseArmor = freezed,
    Object strength = freezed,
    Object dexterity = freezed,
    Object constitution = freezed,
    Object wisdom = freezed,
    Object intelligence = freezed,
    Object charisma = freezed,
    Object playerClass = freezed,
    Object alignment = freezed,
    Object customMaxHP = freezed,
    Object level = freezed,
    Object bio = freezed,
    Object customCurrentHP = freezed,
    Object currentXP = freezed,
    Object moves = freezed,
    Object notes = freezed,
    Object spells = freezed,
    Object inventory = freezed,
    Object customDamageDice = freezed,
    Object looks = freezed,
    Object raceMove = freezed,
    Object coins = freezed,
    Object order = freezed,
    Object customSettings = freezed,
  }) {
    return _then(_Character(
      key: key == freezed ? _value.key : key as String,
      ref: ref == freezed ? _value.ref : ref as DocumentReference,
      displayName:
          displayName == freezed ? _value.displayName : displayName as String,
      photoURL: photoURL == freezed ? _value.photoURL : photoURL as String,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      baseArmor: baseArmor == freezed ? _value.baseArmor : baseArmor as int,
      strength: strength == freezed ? _value.strength : strength as int,
      dexterity: dexterity == freezed ? _value.dexterity : dexterity as int,
      constitution:
          constitution == freezed ? _value.constitution : constitution as int,
      wisdom: wisdom == freezed ? _value.wisdom : wisdom as int,
      intelligence:
          intelligence == freezed ? _value.intelligence : intelligence as int,
      charisma: charisma == freezed ? _value.charisma : charisma as int,
      playerClass: playerClass == freezed
          ? _value.playerClass
          : playerClass as PlayerClass,
      alignment:
          alignment == freezed ? _value.alignment : alignment as AlignmentName,
      customMaxHP:
          customMaxHP == freezed ? _value.customMaxHP : customMaxHP as int,
      level: level == freezed ? _value.level : level as int,
      bio: bio == freezed ? _value.bio : bio as String,
      customCurrentHP: customCurrentHP == freezed
          ? _value.customCurrentHP
          : customCurrentHP as int,
      currentXP: currentXP == freezed ? _value.currentXP : currentXP as int,
      moves: moves == freezed ? _value.moves : moves as List<Move>,
      notes: notes == freezed ? _value.notes : notes as List<Note>,
      spells: spells == freezed ? _value.spells : spells as List<DbSpell>,
      inventory: inventory == freezed
          ? _value.inventory
          : inventory as List<InventoryItem>,
      customDamageDice: customDamageDice == freezed
          ? _value.customDamageDice
          : customDamageDice as Dice,
      looks: looks == freezed ? _value.looks : looks as List<String>,
      raceMove: raceMove == freezed ? _value.raceMove : raceMove as Move,
      coins: coins == freezed ? _value.coins : coins as double,
      order: order == freezed ? _value.order : order as int,
      customSettings: customSettings == freezed
          ? _value.customSettings
          : customSettings as CharacterSettings,
    ));
  }
}

@JsonSerializable()
@With(FirebaseMixin)
@With(CharacterFirebaseMixin)
@With(KeyMixin)

/// @nodoc
class _$_Character extends _Character
    with FirebaseMixin, CharacterFirebaseMixin, KeyMixin {
  _$_Character(
      {@required
      @DefaultUuid()
          this.key,
      @DocumentReferenceConverter()
          this.ref,
      @JsonKey(defaultValue: 'Traveler')
          this.displayName = 'Traveler',
      @JsonKey(defaultValue: '')
          this.photoURL = '',
      @DateTimeConverter()
          this.createdAt,
      @DateTimeConverter()
          this.updatedAt,
      @JsonKey(name: 'armor', defaultValue: 0)
          this.baseArmor = 0,
      @JsonKey(name: 'str', defaultValue: 8)
          this.strength = 8,
      @JsonKey(name: 'dex', defaultValue: 8)
          this.dexterity = 8,
      @JsonKey(name: 'con', defaultValue: 8)
          this.constitution = 8,
      @JsonKey(name: 'wis', defaultValue: 8)
          this.wisdom = 8,
      @JsonKey(name: 'int', defaultValue: 8)
          this.intelligence = 8,
      @JsonKey(name: 'cha', defaultValue: 0)
          this.charisma = 0,
      @required
      @PlayerClassConverter()
          this.playerClass,
      @JsonKey(defaultValue: AlignmentName.neutral)
          this.alignment = AlignmentName.neutral,
      @JsonKey(name: 'maxHP')
          this.customMaxHP,
      @JsonKey(defaultValue: 1)
          this.level = 1,
      this.bio = '',
      @JsonKey(name: 'currentHP', defaultValue: 100)
          this.customCurrentHP = 100,
      @JsonKey(defaultValue: 0)
          this.currentXP = 0,
      @DWMoveConverter()
      @JsonKey(defaultValue: const [])
          this.moves = const [],
      @NoteConverter()
      @JsonKey(defaultValue: const [])
          this.notes = const [],
      @SpellConverter()
      @JsonKey(defaultValue: const [])
          this.spells = const [],
      @InventoryItemConverter()
      @JsonKey(defaultValue: const [])
          this.inventory = const [],
      @DiceConverter()
      @JsonKey(name: 'hitDice')
          this.customDamageDice,
      @JsonKey(defaultValue: const [])
          this.looks = const [],
      @DWMoveConverter()
      @JsonKey(name: 'race')
          this.raceMove,
      @JsonKey(defaultValue: 0)
          this.coins = 0,
      @JsonKey(defaultValue: 0)
          this.order = 0,
      @JsonKey(name: 'settings')
      @CharacterSettingsConverter()
          this.customSettings})
      : assert(key != null),
        assert(displayName != null),
        assert(photoURL != null),
        assert(baseArmor != null),
        assert(strength != null),
        assert(dexterity != null),
        assert(constitution != null),
        assert(wisdom != null),
        assert(intelligence != null),
        assert(charisma != null),
        assert(playerClass != null),
        assert(alignment != null),
        assert(level != null),
        assert(bio != null),
        assert(customCurrentHP != null),
        assert(currentXP != null),
        assert(moves != null),
        assert(notes != null),
        assert(spells != null),
        assert(inventory != null),
        assert(looks != null),
        assert(coins != null),
        assert(order != null),
        super._();

  factory _$_Character.fromJson(Map<String, dynamic> json) =>
      _$_$_CharacterFromJson(json);

  @override
  @DefaultUuid()
  final String key;
  @override
  @DocumentReferenceConverter()
  final DocumentReference ref;
  @override
  @JsonKey(defaultValue: 'Traveler')
  final String displayName;
  @override
  @JsonKey(defaultValue: '')
  final String photoURL;
  @override
  @DateTimeConverter()
  final DateTime createdAt;
  @override
  @DateTimeConverter()
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'armor', defaultValue: 0)
  final int baseArmor;
  @override
  @JsonKey(name: 'str', defaultValue: 8)
  final int strength;
  @override
  @JsonKey(name: 'dex', defaultValue: 8)
  final int dexterity;
  @override
  @JsonKey(name: 'con', defaultValue: 8)
  final int constitution;
  @override
  @JsonKey(name: 'wis', defaultValue: 8)
  final int wisdom;
  @override
  @JsonKey(name: 'int', defaultValue: 8)
  final int intelligence;
  @override
  @JsonKey(name: 'cha', defaultValue: 0)
  final int charisma;
  @override
  @PlayerClassConverter()
  final PlayerClass playerClass;
  @override
  @JsonKey(defaultValue: AlignmentName.neutral)
  final AlignmentName alignment;
  @override
  @JsonKey(name: 'maxHP')
  final int customMaxHP;
  @override
  @JsonKey(defaultValue: 1)
  final int level;
  @JsonKey(defaultValue: '')
  @override
  final String bio;
  @override
  @JsonKey(name: 'currentHP', defaultValue: 100)
  final int customCurrentHP;
  @override
  @JsonKey(defaultValue: 0)
  final int currentXP;
  @override
  @DWMoveConverter()
  @JsonKey(defaultValue: const [])
  final List<Move> moves;
  @override
  @NoteConverter()
  @JsonKey(defaultValue: const [])
  final List<Note> notes;
  @override
  @SpellConverter()
  @JsonKey(defaultValue: const [])
  final List<DbSpell> spells;
  @override
  @InventoryItemConverter()
  @JsonKey(defaultValue: const [])
  final List<InventoryItem> inventory;
  @override
  @DiceConverter()
  @JsonKey(name: 'hitDice')
  final Dice customDamageDice;
  @override
  @JsonKey(defaultValue: const [])
  final List<String> looks;
  @override
  @DWMoveConverter()
  @JsonKey(name: 'race')
  final Move raceMove;
  @override
  @JsonKey(defaultValue: 0)
  final double coins;
  @override
  @JsonKey(defaultValue: 0)
  final int order;
  @override
  @JsonKey(name: 'settings')
  @CharacterSettingsConverter()
  final CharacterSettings customSettings;

  @override
  String toString() {
    return 'Character(key: $key, ref: $ref, displayName: $displayName, photoURL: $photoURL, createdAt: $createdAt, updatedAt: $updatedAt, baseArmor: $baseArmor, strength: $strength, dexterity: $dexterity, constitution: $constitution, wisdom: $wisdom, intelligence: $intelligence, charisma: $charisma, playerClass: $playerClass, alignment: $alignment, customMaxHP: $customMaxHP, level: $level, bio: $bio, customCurrentHP: $customCurrentHP, currentXP: $currentXP, moves: $moves, notes: $notes, spells: $spells, inventory: $inventory, customDamageDice: $customDamageDice, looks: $looks, raceMove: $raceMove, coins: $coins, order: $order, customSettings: $customSettings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Character &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.ref, ref) ||
                const DeepCollectionEquality().equals(other.ref, ref)) &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality()
                    .equals(other.displayName, displayName)) &&
            (identical(other.photoURL, photoURL) ||
                const DeepCollectionEquality()
                    .equals(other.photoURL, photoURL)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.baseArmor, baseArmor) ||
                const DeepCollectionEquality()
                    .equals(other.baseArmor, baseArmor)) &&
            (identical(other.strength, strength) ||
                const DeepCollectionEquality()
                    .equals(other.strength, strength)) &&
            (identical(other.dexterity, dexterity) ||
                const DeepCollectionEquality()
                    .equals(other.dexterity, dexterity)) &&
            (identical(other.constitution, constitution) ||
                const DeepCollectionEquality()
                    .equals(other.constitution, constitution)) &&
            (identical(other.wisdom, wisdom) ||
                const DeepCollectionEquality().equals(other.wisdom, wisdom)) &&
            (identical(other.intelligence, intelligence) ||
                const DeepCollectionEquality()
                    .equals(other.intelligence, intelligence)) &&
            (identical(other.charisma, charisma) ||
                const DeepCollectionEquality()
                    .equals(other.charisma, charisma)) &&
            (identical(other.playerClass, playerClass) ||
                const DeepCollectionEquality()
                    .equals(other.playerClass, playerClass)) &&
            (identical(other.alignment, alignment) ||
                const DeepCollectionEquality()
                    .equals(other.alignment, alignment)) &&
            (identical(other.customMaxHP, customMaxHP) ||
                const DeepCollectionEquality()
                    .equals(other.customMaxHP, customMaxHP)) &&
            (identical(other.level, level) ||
                const DeepCollectionEquality().equals(other.level, level)) &&
            (identical(other.bio, bio) ||
                const DeepCollectionEquality().equals(other.bio, bio)) &&
            (identical(other.customCurrentHP, customCurrentHP) ||
                const DeepCollectionEquality()
                    .equals(other.customCurrentHP, customCurrentHP)) &&
            (identical(other.currentXP, currentXP) ||
                const DeepCollectionEquality()
                    .equals(other.currentXP, currentXP)) &&
            (identical(other.moves, moves) ||
                const DeepCollectionEquality().equals(other.moves, moves)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)) &&
            (identical(other.spells, spells) ||
                const DeepCollectionEquality().equals(other.spells, spells)) &&
            (identical(other.inventory, inventory) ||
                const DeepCollectionEquality()
                    .equals(other.inventory, inventory)) &&
            (identical(other.customDamageDice, customDamageDice) ||
                const DeepCollectionEquality()
                    .equals(other.customDamageDice, customDamageDice)) &&
            (identical(other.looks, looks) ||
                const DeepCollectionEquality().equals(other.looks, looks)) &&
            (identical(other.raceMove, raceMove) || const DeepCollectionEquality().equals(other.raceMove, raceMove)) &&
            (identical(other.coins, coins) || const DeepCollectionEquality().equals(other.coins, coins)) &&
            (identical(other.order, order) || const DeepCollectionEquality().equals(other.order, order)) &&
            (identical(other.customSettings, customSettings) || const DeepCollectionEquality().equals(other.customSettings, customSettings)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(ref) ^
      const DeepCollectionEquality().hash(displayName) ^
      const DeepCollectionEquality().hash(photoURL) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(baseArmor) ^
      const DeepCollectionEquality().hash(strength) ^
      const DeepCollectionEquality().hash(dexterity) ^
      const DeepCollectionEquality().hash(constitution) ^
      const DeepCollectionEquality().hash(wisdom) ^
      const DeepCollectionEquality().hash(intelligence) ^
      const DeepCollectionEquality().hash(charisma) ^
      const DeepCollectionEquality().hash(playerClass) ^
      const DeepCollectionEquality().hash(alignment) ^
      const DeepCollectionEquality().hash(customMaxHP) ^
      const DeepCollectionEquality().hash(level) ^
      const DeepCollectionEquality().hash(bio) ^
      const DeepCollectionEquality().hash(customCurrentHP) ^
      const DeepCollectionEquality().hash(currentXP) ^
      const DeepCollectionEquality().hash(moves) ^
      const DeepCollectionEquality().hash(notes) ^
      const DeepCollectionEquality().hash(spells) ^
      const DeepCollectionEquality().hash(inventory) ^
      const DeepCollectionEquality().hash(customDamageDice) ^
      const DeepCollectionEquality().hash(looks) ^
      const DeepCollectionEquality().hash(raceMove) ^
      const DeepCollectionEquality().hash(coins) ^
      const DeepCollectionEquality().hash(order) ^
      const DeepCollectionEquality().hash(customSettings);

  @JsonKey(ignore: true)
  @override
  _$CharacterCopyWith<_Character> get copyWith =>
      __$CharacterCopyWithImpl<_Character>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CharacterToJson(this);
  }
}

abstract class _Character extends Character
    implements FirebaseMixin, CharacterFirebaseMixin, KeyMixin {
  _Character._() : super._();
  factory _Character(
      {@required
      @DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @JsonKey(defaultValue: 'Traveler')
          String displayName,
      @JsonKey(defaultValue: '')
          String photoURL,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(name: 'armor', defaultValue: 0)
          int baseArmor,
      @JsonKey(name: 'str', defaultValue: 8)
          int strength,
      @JsonKey(name: 'dex', defaultValue: 8)
          int dexterity,
      @JsonKey(name: 'con', defaultValue: 8)
          int constitution,
      @JsonKey(name: 'wis', defaultValue: 8)
          int wisdom,
      @JsonKey(name: 'int', defaultValue: 8)
          int intelligence,
      @JsonKey(name: 'cha', defaultValue: 0)
          int charisma,
      @required
      @PlayerClassConverter()
          PlayerClass playerClass,
      @JsonKey(defaultValue: AlignmentName.neutral)
          AlignmentName alignment,
      @JsonKey(name: 'maxHP')
          int customMaxHP,
      @JsonKey(defaultValue: 1)
          int level,
      String bio,
      @JsonKey(name: 'currentHP', defaultValue: 100)
          int customCurrentHP,
      @JsonKey(defaultValue: 0)
          int currentXP,
      @DWMoveConverter()
      @JsonKey(defaultValue: const [])
          List<Move> moves,
      @NoteConverter()
      @JsonKey(defaultValue: const [])
          List<Note> notes,
      @SpellConverter()
      @JsonKey(defaultValue: const [])
          List<DbSpell> spells,
      @InventoryItemConverter()
      @JsonKey(defaultValue: const [])
          List<InventoryItem> inventory,
      @DiceConverter()
      @JsonKey(name: 'hitDice')
          Dice customDamageDice,
      @JsonKey(defaultValue: const [])
          List<String> looks,
      @DWMoveConverter()
      @JsonKey(name: 'race')
          Move raceMove,
      @JsonKey(defaultValue: 0)
          double coins,
      @JsonKey(defaultValue: 0)
          int order,
      @JsonKey(name: 'settings')
      @CharacterSettingsConverter()
          CharacterSettings customSettings}) = _$_Character;

  factory _Character.fromJson(Map<String, dynamic> json) =
      _$_Character.fromJson;

  @override
  @DefaultUuid()
  String get key;
  @override
  @DocumentReferenceConverter()
  DocumentReference get ref;
  @override
  @JsonKey(defaultValue: 'Traveler')
  String get displayName;
  @override
  @JsonKey(defaultValue: '')
  String get photoURL;
  @override
  @DateTimeConverter()
  DateTime get createdAt;
  @override
  @DateTimeConverter()
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'armor', defaultValue: 0)
  int get baseArmor;
  @override
  @JsonKey(name: 'str', defaultValue: 8)
  int get strength;
  @override
  @JsonKey(name: 'dex', defaultValue: 8)
  int get dexterity;
  @override
  @JsonKey(name: 'con', defaultValue: 8)
  int get constitution;
  @override
  @JsonKey(name: 'wis', defaultValue: 8)
  int get wisdom;
  @override
  @JsonKey(name: 'int', defaultValue: 8)
  int get intelligence;
  @override
  @JsonKey(name: 'cha', defaultValue: 0)
  int get charisma;
  @override
  @PlayerClassConverter()
  PlayerClass get playerClass;
  @override
  @JsonKey(defaultValue: AlignmentName.neutral)
  AlignmentName get alignment;
  @override
  @JsonKey(name: 'maxHP')
  int get customMaxHP;
  @override
  @JsonKey(defaultValue: 1)
  int get level;
  @override
  String get bio;
  @override
  @JsonKey(name: 'currentHP', defaultValue: 100)
  int get customCurrentHP;
  @override
  @JsonKey(defaultValue: 0)
  int get currentXP;
  @override
  @DWMoveConverter()
  @JsonKey(defaultValue: const [])
  List<Move> get moves;
  @override
  @NoteConverter()
  @JsonKey(defaultValue: const [])
  List<Note> get notes;
  @override
  @SpellConverter()
  @JsonKey(defaultValue: const [])
  List<DbSpell> get spells;
  @override
  @InventoryItemConverter()
  @JsonKey(defaultValue: const [])
  List<InventoryItem> get inventory;
  @override
  @DiceConverter()
  @JsonKey(name: 'hitDice')
  Dice get customDamageDice;
  @override
  @JsonKey(defaultValue: const [])
  List<String> get looks;
  @override
  @DWMoveConverter()
  @JsonKey(name: 'race')
  Move get raceMove;
  @override
  @JsonKey(defaultValue: 0)
  double get coins;
  @override
  @JsonKey(defaultValue: 0)
  int get order;
  @override
  @JsonKey(name: 'settings')
  @CharacterSettingsConverter()
  CharacterSettings get customSettings;
  @override
  @JsonKey(ignore: true)
  _$CharacterCopyWith<_Character> get copyWith;
}
