// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'custom_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
CustomClass _$CustomClassFromJson(Map<String, dynamic> json) {
  return _CustomClass.fromJson(json);
}

/// @nodoc
class _$CustomClassTearOff {
  const _$CustomClassTearOff();

// ignore: unused_element
  _CustomClass call(
      {@required
      @DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(defaultValue: '')
          String name = '',
      @JsonKey(defaultValue: '')
          String description = '',
      @JsonKey(defaultValue: 0)
          num load = 0,
      @JsonKey(defaultValue: 0)
          num baseHP = 0,
      @DiceConverter()
          Dice damage,
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> names = const {},
      @JsonKey(defaultValue: const [])
          List<String> bonds = const [],
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> looks = const {},
      @JsonKey(defaultValue: const {})
      @DWAlignmentConverter()
          Map<String, Alignment> alignments = const {},
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> raceMoves = const [],
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> startingMoves = const [],
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves1 = const [],
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves2 = const [],
      @DWSpellConverter()
          List<Spell> spells,
      @JsonKey(defaultValue: const [])
      @DWGearChoiceConverter()
          List<GearChoice> gearChoices = const []}) {
    return _CustomClass(
      key: key,
      ref: ref,
      createdAt: createdAt,
      updatedAt: updatedAt,
      name: name,
      description: description,
      load: load,
      baseHP: baseHP,
      damage: damage,
      names: names,
      bonds: bonds,
      looks: looks,
      alignments: alignments,
      raceMoves: raceMoves,
      startingMoves: startingMoves,
      advancedMoves1: advancedMoves1,
      advancedMoves2: advancedMoves2,
      spells: spells,
      gearChoices: gearChoices,
    );
  }

// ignore: unused_element
  CustomClass fromJson(Map<String, Object> json) {
    return CustomClass.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $CustomClass = _$CustomClassTearOff();

/// @nodoc
mixin _$CustomClass {
  @DefaultUuid()
  String get key;
  @DocumentReferenceConverter()
  DocumentReference get ref;
  @DateTimeConverter()
  DateTime get createdAt;
  @DateTimeConverter()
  DateTime get updatedAt;
  @JsonKey(defaultValue: '')
  String get name;
  @JsonKey(defaultValue: '')
  String get description;
  @JsonKey(defaultValue: 0)
  num get load;
  @JsonKey(defaultValue: 0)
  num get baseHP;
  @DiceConverter()
  Dice get damage;
  @JsonKey(defaultValue: const {})
  Map<String, List<String>> get names;
  @JsonKey(defaultValue: const [])
  List<String> get bonds;
  @JsonKey(defaultValue: const {})
  Map<String, List<String>> get looks;
  @JsonKey(defaultValue: const {})
  @DWAlignmentConverter()
  Map<String, Alignment> get alignments;
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get raceMoves;
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get startingMoves;
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get advancedMoves1;
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get advancedMoves2;
  @DWSpellConverter()
  List<Spell> get spells;
  @JsonKey(defaultValue: const [])
  @DWGearChoiceConverter()
  List<GearChoice> get gearChoices;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $CustomClassCopyWith<CustomClass> get copyWith;
}

/// @nodoc
abstract class $CustomClassCopyWith<$Res> {
  factory $CustomClassCopyWith(
          CustomClass value, $Res Function(CustomClass) then) =
      _$CustomClassCopyWithImpl<$Res>;
  $Res call(
      {@DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(defaultValue: '')
          String name,
      @JsonKey(defaultValue: '')
          String description,
      @JsonKey(defaultValue: 0)
          num load,
      @JsonKey(defaultValue: 0)
          num baseHP,
      @DiceConverter()
          Dice damage,
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> names,
      @JsonKey(defaultValue: const [])
          List<String> bonds,
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> looks,
      @JsonKey(defaultValue: const {})
      @DWAlignmentConverter()
          Map<String, Alignment> alignments,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> raceMoves,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> startingMoves,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves1,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves2,
      @DWSpellConverter()
          List<Spell> spells,
      @JsonKey(defaultValue: const [])
      @DWGearChoiceConverter()
          List<GearChoice> gearChoices});
}

/// @nodoc
class _$CustomClassCopyWithImpl<$Res> implements $CustomClassCopyWith<$Res> {
  _$CustomClassCopyWithImpl(this._value, this._then);

  final CustomClass _value;
  // ignore: unused_field
  final $Res Function(CustomClass) _then;

  @override
  $Res call({
    Object key = freezed,
    Object ref = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object name = freezed,
    Object description = freezed,
    Object load = freezed,
    Object baseHP = freezed,
    Object damage = freezed,
    Object names = freezed,
    Object bonds = freezed,
    Object looks = freezed,
    Object alignments = freezed,
    Object raceMoves = freezed,
    Object startingMoves = freezed,
    Object advancedMoves1 = freezed,
    Object advancedMoves2 = freezed,
    Object spells = freezed,
    Object gearChoices = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed ? _value.key : key as String,
      ref: ref == freezed ? _value.ref : ref as DocumentReference,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      name: name == freezed ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String,
      load: load == freezed ? _value.load : load as num,
      baseHP: baseHP == freezed ? _value.baseHP : baseHP as num,
      damage: damage == freezed ? _value.damage : damage as Dice,
      names:
          names == freezed ? _value.names : names as Map<String, List<String>>,
      bonds: bonds == freezed ? _value.bonds : bonds as List<String>,
      looks:
          looks == freezed ? _value.looks : looks as Map<String, List<String>>,
      alignments: alignments == freezed
          ? _value.alignments
          : alignments as Map<String, Alignment>,
      raceMoves:
          raceMoves == freezed ? _value.raceMoves : raceMoves as List<Move>,
      startingMoves: startingMoves == freezed
          ? _value.startingMoves
          : startingMoves as List<Move>,
      advancedMoves1: advancedMoves1 == freezed
          ? _value.advancedMoves1
          : advancedMoves1 as List<Move>,
      advancedMoves2: advancedMoves2 == freezed
          ? _value.advancedMoves2
          : advancedMoves2 as List<Move>,
      spells: spells == freezed ? _value.spells : spells as List<Spell>,
      gearChoices: gearChoices == freezed
          ? _value.gearChoices
          : gearChoices as List<GearChoice>,
    ));
  }
}

/// @nodoc
abstract class _$CustomClassCopyWith<$Res>
    implements $CustomClassCopyWith<$Res> {
  factory _$CustomClassCopyWith(
          _CustomClass value, $Res Function(_CustomClass) then) =
      __$CustomClassCopyWithImpl<$Res>;
  @override
  $Res call(
      {@DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(defaultValue: '')
          String name,
      @JsonKey(defaultValue: '')
          String description,
      @JsonKey(defaultValue: 0)
          num load,
      @JsonKey(defaultValue: 0)
          num baseHP,
      @DiceConverter()
          Dice damage,
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> names,
      @JsonKey(defaultValue: const [])
          List<String> bonds,
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> looks,
      @JsonKey(defaultValue: const {})
      @DWAlignmentConverter()
          Map<String, Alignment> alignments,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> raceMoves,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> startingMoves,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves1,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves2,
      @DWSpellConverter()
          List<Spell> spells,
      @JsonKey(defaultValue: const [])
      @DWGearChoiceConverter()
          List<GearChoice> gearChoices});
}

/// @nodoc
class __$CustomClassCopyWithImpl<$Res> extends _$CustomClassCopyWithImpl<$Res>
    implements _$CustomClassCopyWith<$Res> {
  __$CustomClassCopyWithImpl(
      _CustomClass _value, $Res Function(_CustomClass) _then)
      : super(_value, (v) => _then(v as _CustomClass));

  @override
  _CustomClass get _value => super._value as _CustomClass;

  @override
  $Res call({
    Object key = freezed,
    Object ref = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object name = freezed,
    Object description = freezed,
    Object load = freezed,
    Object baseHP = freezed,
    Object damage = freezed,
    Object names = freezed,
    Object bonds = freezed,
    Object looks = freezed,
    Object alignments = freezed,
    Object raceMoves = freezed,
    Object startingMoves = freezed,
    Object advancedMoves1 = freezed,
    Object advancedMoves2 = freezed,
    Object spells = freezed,
    Object gearChoices = freezed,
  }) {
    return _then(_CustomClass(
      key: key == freezed ? _value.key : key as String,
      ref: ref == freezed ? _value.ref : ref as DocumentReference,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      name: name == freezed ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String,
      load: load == freezed ? _value.load : load as num,
      baseHP: baseHP == freezed ? _value.baseHP : baseHP as num,
      damage: damage == freezed ? _value.damage : damage as Dice,
      names:
          names == freezed ? _value.names : names as Map<String, List<String>>,
      bonds: bonds == freezed ? _value.bonds : bonds as List<String>,
      looks:
          looks == freezed ? _value.looks : looks as Map<String, List<String>>,
      alignments: alignments == freezed
          ? _value.alignments
          : alignments as Map<String, Alignment>,
      raceMoves:
          raceMoves == freezed ? _value.raceMoves : raceMoves as List<Move>,
      startingMoves: startingMoves == freezed
          ? _value.startingMoves
          : startingMoves as List<Move>,
      advancedMoves1: advancedMoves1 == freezed
          ? _value.advancedMoves1
          : advancedMoves1 as List<Move>,
      advancedMoves2: advancedMoves2 == freezed
          ? _value.advancedMoves2
          : advancedMoves2 as List<Move>,
      spells: spells == freezed ? _value.spells : spells as List<Spell>,
      gearChoices: gearChoices == freezed
          ? _value.gearChoices
          : gearChoices as List<GearChoice>,
    ));
  }
}

@JsonSerializable()
@With(FirebaseMixin)
@With(KeyMixin)

/// @nodoc
class _$_CustomClass extends _CustomClass with FirebaseMixin, KeyMixin {
  const _$_CustomClass(
      {@required
      @DefaultUuid()
          this.key,
      @DocumentReferenceConverter()
          this.ref,
      @DateTimeConverter()
          this.createdAt,
      @DateTimeConverter()
          this.updatedAt,
      @JsonKey(defaultValue: '')
          this.name = '',
      @JsonKey(defaultValue: '')
          this.description = '',
      @JsonKey(defaultValue: 0)
          this.load = 0,
      @JsonKey(defaultValue: 0)
          this.baseHP = 0,
      @DiceConverter()
          this.damage,
      @JsonKey(defaultValue: const {})
          this.names = const {},
      @JsonKey(defaultValue: const [])
          this.bonds = const [],
      @JsonKey(defaultValue: const {})
          this.looks = const {},
      @JsonKey(defaultValue: const {})
      @DWAlignmentConverter()
          this.alignments = const {},
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          this.raceMoves = const [],
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          this.startingMoves = const [],
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          this.advancedMoves1 = const [],
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          this.advancedMoves2 = const [],
      @DWSpellConverter()
          this.spells,
      @JsonKey(defaultValue: const [])
      @DWGearChoiceConverter()
          this.gearChoices = const []})
      : assert(key != null),
        assert(name != null),
        assert(description != null),
        assert(load != null),
        assert(baseHP != null),
        assert(names != null),
        assert(bonds != null),
        assert(looks != null),
        assert(alignments != null),
        assert(raceMoves != null),
        assert(startingMoves != null),
        assert(advancedMoves1 != null),
        assert(advancedMoves2 != null),
        assert(gearChoices != null),
        super._();

  factory _$_CustomClass.fromJson(Map<String, dynamic> json) =>
      _$_$_CustomClassFromJson(json);

  @override
  @DefaultUuid()
  final String key;
  @override
  @DocumentReferenceConverter()
  final DocumentReference ref;
  @override
  @DateTimeConverter()
  final DateTime createdAt;
  @override
  @DateTimeConverter()
  final DateTime updatedAt;
  @override
  @JsonKey(defaultValue: '')
  final String name;
  @override
  @JsonKey(defaultValue: '')
  final String description;
  @override
  @JsonKey(defaultValue: 0)
  final num load;
  @override
  @JsonKey(defaultValue: 0)
  final num baseHP;
  @override
  @DiceConverter()
  final Dice damage;
  @override
  @JsonKey(defaultValue: const {})
  final Map<String, List<String>> names;
  @override
  @JsonKey(defaultValue: const [])
  final List<String> bonds;
  @override
  @JsonKey(defaultValue: const {})
  final Map<String, List<String>> looks;
  @override
  @JsonKey(defaultValue: const {})
  @DWAlignmentConverter()
  final Map<String, Alignment> alignments;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  final List<Move> raceMoves;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  final List<Move> startingMoves;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  final List<Move> advancedMoves1;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  final List<Move> advancedMoves2;
  @override
  @DWSpellConverter()
  final List<Spell> spells;
  @override
  @JsonKey(defaultValue: const [])
  @DWGearChoiceConverter()
  final List<GearChoice> gearChoices;

  @override
  String toString() {
    return 'CustomClass(key: $key, ref: $ref, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, description: $description, load: $load, baseHP: $baseHP, damage: $damage, names: $names, bonds: $bonds, looks: $looks, alignments: $alignments, raceMoves: $raceMoves, startingMoves: $startingMoves, advancedMoves1: $advancedMoves1, advancedMoves2: $advancedMoves2, spells: $spells, gearChoices: $gearChoices)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CustomClass &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.ref, ref) ||
                const DeepCollectionEquality().equals(other.ref, ref)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.load, load) ||
                const DeepCollectionEquality().equals(other.load, load)) &&
            (identical(other.baseHP, baseHP) ||
                const DeepCollectionEquality().equals(other.baseHP, baseHP)) &&
            (identical(other.damage, damage) ||
                const DeepCollectionEquality().equals(other.damage, damage)) &&
            (identical(other.names, names) ||
                const DeepCollectionEquality().equals(other.names, names)) &&
            (identical(other.bonds, bonds) ||
                const DeepCollectionEquality().equals(other.bonds, bonds)) &&
            (identical(other.looks, looks) ||
                const DeepCollectionEquality().equals(other.looks, looks)) &&
            (identical(other.alignments, alignments) ||
                const DeepCollectionEquality()
                    .equals(other.alignments, alignments)) &&
            (identical(other.raceMoves, raceMoves) ||
                const DeepCollectionEquality()
                    .equals(other.raceMoves, raceMoves)) &&
            (identical(other.startingMoves, startingMoves) ||
                const DeepCollectionEquality()
                    .equals(other.startingMoves, startingMoves)) &&
            (identical(other.advancedMoves1, advancedMoves1) ||
                const DeepCollectionEquality()
                    .equals(other.advancedMoves1, advancedMoves1)) &&
            (identical(other.advancedMoves2, advancedMoves2) ||
                const DeepCollectionEquality()
                    .equals(other.advancedMoves2, advancedMoves2)) &&
            (identical(other.spells, spells) ||
                const DeepCollectionEquality().equals(other.spells, spells)) &&
            (identical(other.gearChoices, gearChoices) ||
                const DeepCollectionEquality()
                    .equals(other.gearChoices, gearChoices)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(ref) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(load) ^
      const DeepCollectionEquality().hash(baseHP) ^
      const DeepCollectionEquality().hash(damage) ^
      const DeepCollectionEquality().hash(names) ^
      const DeepCollectionEquality().hash(bonds) ^
      const DeepCollectionEquality().hash(looks) ^
      const DeepCollectionEquality().hash(alignments) ^
      const DeepCollectionEquality().hash(raceMoves) ^
      const DeepCollectionEquality().hash(startingMoves) ^
      const DeepCollectionEquality().hash(advancedMoves1) ^
      const DeepCollectionEquality().hash(advancedMoves2) ^
      const DeepCollectionEquality().hash(spells) ^
      const DeepCollectionEquality().hash(gearChoices);

  @JsonKey(ignore: true)
  @override
  _$CustomClassCopyWith<_CustomClass> get copyWith =>
      __$CustomClassCopyWithImpl<_CustomClass>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CustomClassToJson(this);
  }
}

abstract class _CustomClass extends CustomClass
    implements FirebaseMixin, KeyMixin {
  const _CustomClass._() : super._();
  const factory _CustomClass(
      {@required
      @DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      @JsonKey(defaultValue: '')
          String name,
      @JsonKey(defaultValue: '')
          String description,
      @JsonKey(defaultValue: 0)
          num load,
      @JsonKey(defaultValue: 0)
          num baseHP,
      @DiceConverter()
          Dice damage,
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> names,
      @JsonKey(defaultValue: const [])
          List<String> bonds,
      @JsonKey(defaultValue: const {})
          Map<String, List<String>> looks,
      @JsonKey(defaultValue: const {})
      @DWAlignmentConverter()
          Map<String, Alignment> alignments,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> raceMoves,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> startingMoves,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves1,
      @JsonKey(defaultValue: const [])
      @DWMoveConverter()
          List<Move> advancedMoves2,
      @DWSpellConverter()
          List<Spell> spells,
      @JsonKey(defaultValue: const [])
      @DWGearChoiceConverter()
          List<GearChoice> gearChoices}) = _$_CustomClass;

  factory _CustomClass.fromJson(Map<String, dynamic> json) =
      _$_CustomClass.fromJson;

  @override
  @DefaultUuid()
  String get key;
  @override
  @DocumentReferenceConverter()
  DocumentReference get ref;
  @override
  @DateTimeConverter()
  DateTime get createdAt;
  @override
  @DateTimeConverter()
  DateTime get updatedAt;
  @override
  @JsonKey(defaultValue: '')
  String get name;
  @override
  @JsonKey(defaultValue: '')
  String get description;
  @override
  @JsonKey(defaultValue: 0)
  num get load;
  @override
  @JsonKey(defaultValue: 0)
  num get baseHP;
  @override
  @DiceConverter()
  Dice get damage;
  @override
  @JsonKey(defaultValue: const {})
  Map<String, List<String>> get names;
  @override
  @JsonKey(defaultValue: const [])
  List<String> get bonds;
  @override
  @JsonKey(defaultValue: const {})
  Map<String, List<String>> get looks;
  @override
  @JsonKey(defaultValue: const {})
  @DWAlignmentConverter()
  Map<String, Alignment> get alignments;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get raceMoves;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get startingMoves;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get advancedMoves1;
  @override
  @JsonKey(defaultValue: const [])
  @DWMoveConverter()
  List<Move> get advancedMoves2;
  @override
  @DWSpellConverter()
  List<Spell> get spells;
  @override
  @JsonKey(defaultValue: const [])
  @DWGearChoiceConverter()
  List<GearChoice> get gearChoices;
  @override
  @JsonKey(ignore: true)
  _$CustomClassCopyWith<_CustomClass> get copyWith;
}
