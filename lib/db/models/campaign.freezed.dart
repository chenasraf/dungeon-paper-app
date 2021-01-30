// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'campaign.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Campaign _$CampaignFromJson(Map<String, dynamic> json) {
  return _Campaign.fromJson(json);
}

/// @nodoc
class _$CampaignTearOff {
  const _$CampaignTearOff();

// ignore: unused_element
  _Campaign call(
      {@required
      @DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      String name = 'Our Campaign',
      String description = '',
      User owner,
      @DocumentReferenceConverter()
      @JsonKey(name: 'characters')
          List<DocumentReference> characterRefs}) {
    return _Campaign(
      key: key,
      ref: ref,
      createdAt: createdAt,
      updatedAt: updatedAt,
      name: name,
      description: description,
      owner: owner,
      characterRefs: characterRefs,
    );
  }

// ignore: unused_element
  Campaign fromJson(Map<String, Object> json) {
    return Campaign.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Campaign = _$CampaignTearOff();

/// @nodoc
mixin _$Campaign {
  @DefaultUuid()
  String get key;
  @DocumentReferenceConverter()
  DocumentReference get ref;
  @DateTimeConverter()
  DateTime get createdAt;
  @DateTimeConverter()
  DateTime get updatedAt;
  String get name;
  String get description;
  User get owner;
  @DocumentReferenceConverter()
  @JsonKey(name: 'characters')
  List<DocumentReference> get characterRefs;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $CampaignCopyWith<Campaign> get copyWith;
}

/// @nodoc
abstract class $CampaignCopyWith<$Res> {
  factory $CampaignCopyWith(Campaign value, $Res Function(Campaign) then) =
      _$CampaignCopyWithImpl<$Res>;
  $Res call(
      {@DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      String name,
      String description,
      User owner,
      @DocumentReferenceConverter()
      @JsonKey(name: 'characters')
          List<DocumentReference> characterRefs});

  $UserCopyWith<$Res> get owner;
}

/// @nodoc
class _$CampaignCopyWithImpl<$Res> implements $CampaignCopyWith<$Res> {
  _$CampaignCopyWithImpl(this._value, this._then);

  final Campaign _value;
  // ignore: unused_field
  final $Res Function(Campaign) _then;

  @override
  $Res call({
    Object key = freezed,
    Object ref = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object name = freezed,
    Object description = freezed,
    Object owner = freezed,
    Object characterRefs = freezed,
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
      owner: owner == freezed ? _value.owner : owner as User,
      characterRefs: characterRefs == freezed
          ? _value.characterRefs
          : characterRefs as List<DocumentReference>,
    ));
  }

  @override
  $UserCopyWith<$Res> get owner {
    if (_value.owner == null) {
      return null;
    }
    return $UserCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value));
    });
  }
}

/// @nodoc
abstract class _$CampaignCopyWith<$Res> implements $CampaignCopyWith<$Res> {
  factory _$CampaignCopyWith(_Campaign value, $Res Function(_Campaign) then) =
      __$CampaignCopyWithImpl<$Res>;
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
      String name,
      String description,
      User owner,
      @DocumentReferenceConverter()
      @JsonKey(name: 'characters')
          List<DocumentReference> characterRefs});

  @override
  $UserCopyWith<$Res> get owner;
}

/// @nodoc
class __$CampaignCopyWithImpl<$Res> extends _$CampaignCopyWithImpl<$Res>
    implements _$CampaignCopyWith<$Res> {
  __$CampaignCopyWithImpl(_Campaign _value, $Res Function(_Campaign) _then)
      : super(_value, (v) => _then(v as _Campaign));

  @override
  _Campaign get _value => super._value as _Campaign;

  @override
  $Res call({
    Object key = freezed,
    Object ref = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object name = freezed,
    Object description = freezed,
    Object owner = freezed,
    Object characterRefs = freezed,
  }) {
    return _then(_Campaign(
      key: key == freezed ? _value.key : key as String,
      ref: ref == freezed ? _value.ref : ref as DocumentReference,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      name: name == freezed ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String,
      owner: owner == freezed ? _value.owner : owner as User,
      characterRefs: characterRefs == freezed
          ? _value.characterRefs
          : characterRefs as List<DocumentReference>,
    ));
  }
}

@JsonSerializable()
@With(FirebaseMixin)
@With(KeyMixin)

/// @nodoc
class _$_Campaign extends _Campaign with FirebaseMixin, KeyMixin {
  const _$_Campaign(
      {@required
      @DefaultUuid()
          this.key,
      @DocumentReferenceConverter()
          this.ref,
      @DateTimeConverter()
          this.createdAt,
      @DateTimeConverter()
          this.updatedAt,
      this.name = 'Our Campaign',
      this.description = '',
      this.owner,
      @DocumentReferenceConverter()
      @JsonKey(name: 'characters')
          this.characterRefs})
      : assert(key != null),
        assert(name != null),
        assert(description != null),
        super._();

  factory _$_Campaign.fromJson(Map<String, dynamic> json) =>
      _$_$_CampaignFromJson(json);

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
  @JsonKey(defaultValue: 'Our Campaign')
  @override
  final String name;
  @JsonKey(defaultValue: '')
  @override
  final String description;
  @override
  final User owner;
  @override
  @DocumentReferenceConverter()
  @JsonKey(name: 'characters')
  final List<DocumentReference> characterRefs;

  @override
  String toString() {
    return 'Campaign(key: $key, ref: $ref, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, description: $description, owner: $owner, characterRefs: $characterRefs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Campaign &&
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
            (identical(other.owner, owner) ||
                const DeepCollectionEquality().equals(other.owner, owner)) &&
            (identical(other.characterRefs, characterRefs) ||
                const DeepCollectionEquality()
                    .equals(other.characterRefs, characterRefs)));
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
      const DeepCollectionEquality().hash(owner) ^
      const DeepCollectionEquality().hash(characterRefs);

  @JsonKey(ignore: true)
  @override
  _$CampaignCopyWith<_Campaign> get copyWith =>
      __$CampaignCopyWithImpl<_Campaign>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CampaignToJson(this);
  }
}

abstract class _Campaign extends Campaign implements FirebaseMixin, KeyMixin {
  const _Campaign._() : super._();
  const factory _Campaign(
      {@required
      @DefaultUuid()
          String key,
      @DocumentReferenceConverter()
          DocumentReference ref,
      @DateTimeConverter()
          DateTime createdAt,
      @DateTimeConverter()
          DateTime updatedAt,
      String name,
      String description,
      User owner,
      @DocumentReferenceConverter()
      @JsonKey(name: 'characters')
          List<DocumentReference> characterRefs}) = _$_Campaign;

  factory _Campaign.fromJson(Map<String, dynamic> json) = _$_Campaign.fromJson;

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
  String get name;
  @override
  String get description;
  @override
  User get owner;
  @override
  @DocumentReferenceConverter()
  @JsonKey(name: 'characters')
  List<DocumentReference> get characterRefs;
  @override
  @JsonKey(ignore: true)
  _$CampaignCopyWith<_Campaign> get copyWith;
}
