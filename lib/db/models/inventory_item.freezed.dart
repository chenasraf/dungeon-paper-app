// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'inventory_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) {
  return _InventoryItem.fromJson(json);
}

/// @nodoc
class _$InventoryItemTearOff {
  const _$InventoryItemTearOff();

// ignore: unused_element
  _InventoryItem call(
      {@required @DefaultUuid() String key,
      @required String name,
      String pluralName,
      String description = '',
      @TagConverter() List<Tag> tags = const [],
      num amount = 1,
      bool equipped = false,
      bool countWeight = true,
      bool countDamage = true,
      bool countArmor = true}) {
    return _InventoryItem(
      key: key,
      name: name,
      pluralName: pluralName,
      description: description,
      tags: tags,
      amount: amount,
      equipped: equipped,
      countWeight: countWeight,
      countDamage: countDamage,
      countArmor: countArmor,
    );
  }

// ignore: unused_element
  InventoryItem fromJson(Map<String, Object> json) {
    return InventoryItem.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $InventoryItem = _$InventoryItemTearOff();

/// @nodoc
mixin _$InventoryItem {
  @DefaultUuid()
  String get key;
  String get name;
  String get pluralName;
  String get description;
  @TagConverter()
  List<Tag> get tags;
  num get amount;
  bool get equipped;
  bool get countWeight;
  bool get countDamage;
  bool get countArmor;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $InventoryItemCopyWith<InventoryItem> get copyWith;
}

/// @nodoc
abstract class $InventoryItemCopyWith<$Res> {
  factory $InventoryItemCopyWith(
          InventoryItem value, $Res Function(InventoryItem) then) =
      _$InventoryItemCopyWithImpl<$Res>;
  $Res call(
      {@DefaultUuid() String key,
      String name,
      String pluralName,
      String description,
      @TagConverter() List<Tag> tags,
      num amount,
      bool equipped,
      bool countWeight,
      bool countDamage,
      bool countArmor});
}

/// @nodoc
class _$InventoryItemCopyWithImpl<$Res>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._value, this._then);

  final InventoryItem _value;
  // ignore: unused_field
  final $Res Function(InventoryItem) _then;

  @override
  $Res call({
    Object key = freezed,
    Object name = freezed,
    Object pluralName = freezed,
    Object description = freezed,
    Object tags = freezed,
    Object amount = freezed,
    Object equipped = freezed,
    Object countWeight = freezed,
    Object countDamage = freezed,
    Object countArmor = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed ? _value.key : key as String,
      name: name == freezed ? _value.name : name as String,
      pluralName:
          pluralName == freezed ? _value.pluralName : pluralName as String,
      description:
          description == freezed ? _value.description : description as String,
      tags: tags == freezed ? _value.tags : tags as List<Tag>,
      amount: amount == freezed ? _value.amount : amount as num,
      equipped: equipped == freezed ? _value.equipped : equipped as bool,
      countWeight:
          countWeight == freezed ? _value.countWeight : countWeight as bool,
      countDamage:
          countDamage == freezed ? _value.countDamage : countDamage as bool,
      countArmor:
          countArmor == freezed ? _value.countArmor : countArmor as bool,
    ));
  }
}

/// @nodoc
abstract class _$InventoryItemCopyWith<$Res>
    implements $InventoryItemCopyWith<$Res> {
  factory _$InventoryItemCopyWith(
          _InventoryItem value, $Res Function(_InventoryItem) then) =
      __$InventoryItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {@DefaultUuid() String key,
      String name,
      String pluralName,
      String description,
      @TagConverter() List<Tag> tags,
      num amount,
      bool equipped,
      bool countWeight,
      bool countDamage,
      bool countArmor});
}

/// @nodoc
class __$InventoryItemCopyWithImpl<$Res>
    extends _$InventoryItemCopyWithImpl<$Res>
    implements _$InventoryItemCopyWith<$Res> {
  __$InventoryItemCopyWithImpl(
      _InventoryItem _value, $Res Function(_InventoryItem) _then)
      : super(_value, (v) => _then(v as _InventoryItem));

  @override
  _InventoryItem get _value => super._value as _InventoryItem;

  @override
  $Res call({
    Object key = freezed,
    Object name = freezed,
    Object pluralName = freezed,
    Object description = freezed,
    Object tags = freezed,
    Object amount = freezed,
    Object equipped = freezed,
    Object countWeight = freezed,
    Object countDamage = freezed,
    Object countArmor = freezed,
  }) {
    return _then(_InventoryItem(
      key: key == freezed ? _value.key : key as String,
      name: name == freezed ? _value.name : name as String,
      pluralName:
          pluralName == freezed ? _value.pluralName : pluralName as String,
      description:
          description == freezed ? _value.description : description as String,
      tags: tags == freezed ? _value.tags : tags as List<Tag>,
      amount: amount == freezed ? _value.amount : amount as num,
      equipped: equipped == freezed ? _value.equipped : equipped as bool,
      countWeight:
          countWeight == freezed ? _value.countWeight : countWeight as bool,
      countDamage:
          countDamage == freezed ? _value.countDamage : countDamage as bool,
      countArmor:
          countArmor == freezed ? _value.countArmor : countArmor as bool,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_InventoryItem extends _InventoryItem {
  const _$_InventoryItem(
      {@required @DefaultUuid() this.key,
      @required this.name,
      this.pluralName,
      this.description = '',
      @TagConverter() this.tags = const [],
      this.amount = 1,
      this.equipped = false,
      this.countWeight = true,
      this.countDamage = true,
      this.countArmor = true})
      : assert(key != null),
        assert(name != null),
        assert(description != null),
        assert(tags != null),
        assert(amount != null),
        assert(equipped != null),
        assert(countWeight != null),
        assert(countDamage != null),
        assert(countArmor != null),
        super._();

  factory _$_InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$_$_InventoryItemFromJson(json);

  @override
  @DefaultUuid()
  final String key;
  @override
  final String name;
  @override
  final String pluralName;
  @JsonKey(defaultValue: '')
  @override
  final String description;
  @JsonKey(defaultValue: const [])
  @override
  @TagConverter()
  final List<Tag> tags;
  @JsonKey(defaultValue: 1)
  @override
  final num amount;
  @JsonKey(defaultValue: false)
  @override
  final bool equipped;
  @JsonKey(defaultValue: true)
  @override
  final bool countWeight;
  @JsonKey(defaultValue: true)
  @override
  final bool countDamage;
  @JsonKey(defaultValue: true)
  @override
  final bool countArmor;

  @override
  String toString() {
    return 'InventoryItem(key: $key, name: $name, pluralName: $pluralName, description: $description, tags: $tags, amount: $amount, equipped: $equipped, countWeight: $countWeight, countDamage: $countDamage, countArmor: $countArmor)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _InventoryItem &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.pluralName, pluralName) ||
                const DeepCollectionEquality()
                    .equals(other.pluralName, pluralName)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)) &&
            (identical(other.amount, amount) ||
                const DeepCollectionEquality().equals(other.amount, amount)) &&
            (identical(other.equipped, equipped) ||
                const DeepCollectionEquality()
                    .equals(other.equipped, equipped)) &&
            (identical(other.countWeight, countWeight) ||
                const DeepCollectionEquality()
                    .equals(other.countWeight, countWeight)) &&
            (identical(other.countDamage, countDamage) ||
                const DeepCollectionEquality()
                    .equals(other.countDamage, countDamage)) &&
            (identical(other.countArmor, countArmor) ||
                const DeepCollectionEquality()
                    .equals(other.countArmor, countArmor)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(pluralName) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(tags) ^
      const DeepCollectionEquality().hash(amount) ^
      const DeepCollectionEquality().hash(equipped) ^
      const DeepCollectionEquality().hash(countWeight) ^
      const DeepCollectionEquality().hash(countDamage) ^
      const DeepCollectionEquality().hash(countArmor);

  @JsonKey(ignore: true)
  @override
  _$InventoryItemCopyWith<_InventoryItem> get copyWith =>
      __$InventoryItemCopyWithImpl<_InventoryItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_InventoryItemToJson(this);
  }
}

abstract class _InventoryItem extends InventoryItem {
  const _InventoryItem._() : super._();
  const factory _InventoryItem(
      {@required @DefaultUuid() String key,
      @required String name,
      String pluralName,
      String description,
      @TagConverter() List<Tag> tags,
      num amount,
      bool equipped,
      bool countWeight,
      bool countDamage,
      bool countArmor}) = _$_InventoryItem;

  factory _InventoryItem.fromJson(Map<String, dynamic> json) =
      _$_InventoryItem.fromJson;

  @override
  @DefaultUuid()
  String get key;
  @override
  String get name;
  @override
  String get pluralName;
  @override
  String get description;
  @override
  @TagConverter()
  List<Tag> get tags;
  @override
  num get amount;
  @override
  bool get equipped;
  @override
  bool get countWeight;
  @override
  bool get countDamage;
  @override
  bool get countArmor;
  @override
  @JsonKey(ignore: true)
  _$InventoryItemCopyWith<_InventoryItem> get copyWith;
}
