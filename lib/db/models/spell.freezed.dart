// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'spell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
DbSpell _$DbSpellFromJson(Map<String, dynamic> json) {
  return _DbSpell.fromJson(json);
}

/// @nodoc
class _$DbSpellTearOff {
  const _$DbSpellTearOff();

// ignore: unused_element
  _DbSpell call(
      {@required @DefaultUuid() String key,
      @required String name,
      String description = '',
      @required String level,
      @TagConverter() List<Tag> tags = const [],
      bool prepared = false}) {
    return _DbSpell(
      key: key,
      name: name,
      description: description,
      level: level,
      tags: tags,
      prepared: prepared,
    );
  }

// ignore: unused_element
  DbSpell fromJson(Map<String, Object> json) {
    return DbSpell.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $DbSpell = _$DbSpellTearOff();

/// @nodoc
mixin _$DbSpell {
  @DefaultUuid()
  String get key;
  String get name;
  String get description;
  String get level;
  @TagConverter()
  List<Tag> get tags;
  bool get prepared;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $DbSpellCopyWith<DbSpell> get copyWith;
}

/// @nodoc
abstract class $DbSpellCopyWith<$Res> {
  factory $DbSpellCopyWith(DbSpell value, $Res Function(DbSpell) then) =
      _$DbSpellCopyWithImpl<$Res>;
  $Res call(
      {@DefaultUuid() String key,
      String name,
      String description,
      String level,
      @TagConverter() List<Tag> tags,
      bool prepared});
}

/// @nodoc
class _$DbSpellCopyWithImpl<$Res> implements $DbSpellCopyWith<$Res> {
  _$DbSpellCopyWithImpl(this._value, this._then);

  final DbSpell _value;
  // ignore: unused_field
  final $Res Function(DbSpell) _then;

  @override
  $Res call({
    Object key = freezed,
    Object name = freezed,
    Object description = freezed,
    Object level = freezed,
    Object tags = freezed,
    Object prepared = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed ? _value.key : key as String,
      name: name == freezed ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String,
      level: level == freezed ? _value.level : level as String,
      tags: tags == freezed ? _value.tags : tags as List<Tag>,
      prepared: prepared == freezed ? _value.prepared : prepared as bool,
    ));
  }
}

/// @nodoc
abstract class _$DbSpellCopyWith<$Res> implements $DbSpellCopyWith<$Res> {
  factory _$DbSpellCopyWith(_DbSpell value, $Res Function(_DbSpell) then) =
      __$DbSpellCopyWithImpl<$Res>;
  @override
  $Res call(
      {@DefaultUuid() String key,
      String name,
      String description,
      String level,
      @TagConverter() List<Tag> tags,
      bool prepared});
}

/// @nodoc
class __$DbSpellCopyWithImpl<$Res> extends _$DbSpellCopyWithImpl<$Res>
    implements _$DbSpellCopyWith<$Res> {
  __$DbSpellCopyWithImpl(_DbSpell _value, $Res Function(_DbSpell) _then)
      : super(_value, (v) => _then(v as _DbSpell));

  @override
  _DbSpell get _value => super._value as _DbSpell;

  @override
  $Res call({
    Object key = freezed,
    Object name = freezed,
    Object description = freezed,
    Object level = freezed,
    Object tags = freezed,
    Object prepared = freezed,
  }) {
    return _then(_DbSpell(
      key: key == freezed ? _value.key : key as String,
      name: name == freezed ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String,
      level: level == freezed ? _value.level : level as String,
      tags: tags == freezed ? _value.tags : tags as List<Tag>,
      prepared: prepared == freezed ? _value.prepared : prepared as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_DbSpell extends _DbSpell {
  const _$_DbSpell(
      {@required @DefaultUuid() this.key,
      @required this.name,
      this.description = '',
      @required this.level,
      @TagConverter() this.tags = const [],
      this.prepared = false})
      : assert(key != null),
        assert(name != null),
        assert(description != null),
        assert(level != null),
        assert(tags != null),
        assert(prepared != null),
        super._();

  factory _$_DbSpell.fromJson(Map<String, dynamic> json) =>
      _$_$_DbSpellFromJson(json);

  @override
  @DefaultUuid()
  final String key;
  @override
  final String name;
  @JsonKey(defaultValue: '')
  @override
  final String description;
  @override
  final String level;
  @JsonKey(defaultValue: const [])
  @override
  @TagConverter()
  final List<Tag> tags;
  @JsonKey(defaultValue: false)
  @override
  final bool prepared;

  @override
  String toString() {
    return 'DbSpell(key: $key, name: $name, description: $description, level: $level, tags: $tags, prepared: $prepared)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DbSpell &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.level, level) ||
                const DeepCollectionEquality().equals(other.level, level)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)) &&
            (identical(other.prepared, prepared) ||
                const DeepCollectionEquality()
                    .equals(other.prepared, prepared)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(level) ^
      const DeepCollectionEquality().hash(tags) ^
      const DeepCollectionEquality().hash(prepared);

  @JsonKey(ignore: true)
  @override
  _$DbSpellCopyWith<_DbSpell> get copyWith =>
      __$DbSpellCopyWithImpl<_DbSpell>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DbSpellToJson(this);
  }
}

abstract class _DbSpell extends DbSpell {
  const _DbSpell._() : super._();
  const factory _DbSpell(
      {@required @DefaultUuid() String key,
      @required String name,
      String description,
      @required String level,
      @TagConverter() List<Tag> tags,
      bool prepared}) = _$_DbSpell;

  factory _DbSpell.fromJson(Map<String, dynamic> json) = _$_DbSpell.fromJson;

  @override
  @DefaultUuid()
  String get key;
  @override
  String get name;
  @override
  String get description;
  @override
  String get level;
  @override
  @TagConverter()
  List<Tag> get tags;
  @override
  bool get prepared;
  @override
  @JsonKey(ignore: true)
  _$DbSpellCopyWith<_DbSpell> get copyWith;
}
