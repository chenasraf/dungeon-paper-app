// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

// ignore: unused_element
  _User call(
      {@required String displayName,
      @required String email,
      String photoURL,
      Map<String, dynamic> features = const {},
      @DocumentReferenceConverter() DocumentReference ref,
      @DateTimeConverter() DateTime createdAt,
      @DateTimeConverter() DateTime updatedAt,
      String lastCharacterId}) {
    return _User(
      displayName: displayName,
      email: email,
      photoURL: photoURL,
      features: features,
      ref: ref,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastCharacterId: lastCharacterId,
    );
  }

// ignore: unused_element
  User fromJson(Map<String, Object> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String get displayName;
  String get email;
  String get photoURL;
  Map<String, dynamic> get features;
  @DocumentReferenceConverter()
  DocumentReference get ref;
  @DateTimeConverter()
  DateTime get createdAt;
  @DateTimeConverter()
  DateTime get updatedAt;
  String get lastCharacterId;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String displayName,
      String email,
      String photoURL,
      Map<String, dynamic> features,
      @DocumentReferenceConverter() DocumentReference ref,
      @DateTimeConverter() DateTime createdAt,
      @DateTimeConverter() DateTime updatedAt,
      String lastCharacterId});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object displayName = freezed,
    Object email = freezed,
    Object photoURL = freezed,
    Object features = freezed,
    Object ref = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object lastCharacterId = freezed,
  }) {
    return _then(_value.copyWith(
      displayName:
          displayName == freezed ? _value.displayName : displayName as String,
      email: email == freezed ? _value.email : email as String,
      photoURL: photoURL == freezed ? _value.photoURL : photoURL as String,
      features: features == freezed
          ? _value.features
          : features as Map<String, dynamic>,
      ref: ref == freezed ? _value.ref : ref as DocumentReference,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      lastCharacterId: lastCharacterId == freezed
          ? _value.lastCharacterId
          : lastCharacterId as String,
    ));
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String displayName,
      String email,
      String photoURL,
      Map<String, dynamic> features,
      @DocumentReferenceConverter() DocumentReference ref,
      @DateTimeConverter() DateTime createdAt,
      @DateTimeConverter() DateTime updatedAt,
      String lastCharacterId});
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object displayName = freezed,
    Object email = freezed,
    Object photoURL = freezed,
    Object features = freezed,
    Object ref = freezed,
    Object createdAt = freezed,
    Object updatedAt = freezed,
    Object lastCharacterId = freezed,
  }) {
    return _then(_User(
      displayName:
          displayName == freezed ? _value.displayName : displayName as String,
      email: email == freezed ? _value.email : email as String,
      photoURL: photoURL == freezed ? _value.photoURL : photoURL as String,
      features: features == freezed
          ? _value.features
          : features as Map<String, dynamic>,
      ref: ref == freezed ? _value.ref : ref as DocumentReference,
      createdAt:
          createdAt == freezed ? _value.createdAt : createdAt as DateTime,
      updatedAt:
          updatedAt == freezed ? _value.updatedAt : updatedAt as DateTime,
      lastCharacterId: lastCharacterId == freezed
          ? _value.lastCharacterId
          : lastCharacterId as String,
    ));
  }
}

@JsonSerializable()
@With(FirebaseMixin)

/// @nodoc
class _$_User extends _User with DiagnosticableTreeMixin, FirebaseMixin {
  const _$_User(
      {@required this.displayName,
      @required this.email,
      this.photoURL,
      this.features = const {},
      @DocumentReferenceConverter() this.ref,
      @DateTimeConverter() this.createdAt,
      @DateTimeConverter() this.updatedAt,
      this.lastCharacterId})
      : assert(displayName != null),
        assert(email != null),
        assert(features != null),
        super._();

  factory _$_User.fromJson(Map<String, dynamic> json) =>
      _$_$_UserFromJson(json);

  @override
  final String displayName;
  @override
  final String email;
  @override
  final String photoURL;
  @JsonKey(defaultValue: const {})
  @override
  final Map<String, dynamic> features;
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
  final String lastCharacterId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(displayName: $displayName, email: $email, photoURL: $photoURL, features: $features, ref: $ref, createdAt: $createdAt, updatedAt: $updatedAt, lastCharacterId: $lastCharacterId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('photoURL', photoURL))
      ..add(DiagnosticsProperty('features', features))
      ..add(DiagnosticsProperty('ref', ref))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('lastCharacterId', lastCharacterId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality()
                    .equals(other.displayName, displayName)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.photoURL, photoURL) ||
                const DeepCollectionEquality()
                    .equals(other.photoURL, photoURL)) &&
            (identical(other.features, features) ||
                const DeepCollectionEquality()
                    .equals(other.features, features)) &&
            (identical(other.ref, ref) ||
                const DeepCollectionEquality().equals(other.ref, ref)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)) &&
            (identical(other.lastCharacterId, lastCharacterId) ||
                const DeepCollectionEquality()
                    .equals(other.lastCharacterId, lastCharacterId)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(displayName) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(photoURL) ^
      const DeepCollectionEquality().hash(features) ^
      const DeepCollectionEquality().hash(ref) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(lastCharacterId);

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserToJson(this);
  }
}

abstract class _User extends User implements FirebaseMixin {
  const _User._() : super._();
  const factory _User(
      {@required String displayName,
      @required String email,
      String photoURL,
      Map<String, dynamic> features,
      @DocumentReferenceConverter() DocumentReference ref,
      @DateTimeConverter() DateTime createdAt,
      @DateTimeConverter() DateTime updatedAt,
      String lastCharacterId}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get displayName;
  @override
  String get email;
  @override
  String get photoURL;
  @override
  Map<String, dynamic> get features;
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
  String get lastCharacterId;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith;
}
