// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'character_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
CharacterSettings _$CharacterSettingsFromJson(Map<String, dynamic> json) {
  return _CharacterSettings.fromJson(json);
}

/// @nodoc
class _$CharacterSettingsTearOff {
  const _$CharacterSettingsTearOff();

// ignore: unused_element
  _CharacterSettings call(
      {bool useDefaultMaxHp = true,
      @FlutterAlignmentConverter() Alignment photoAlignment}) {
    return _CharacterSettings(
      useDefaultMaxHp: useDefaultMaxHp,
      photoAlignment: photoAlignment,
    );
  }

// ignore: unused_element
  CharacterSettings fromJson(Map<String, Object> json) {
    return CharacterSettings.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $CharacterSettings = _$CharacterSettingsTearOff();

/// @nodoc
mixin _$CharacterSettings {
  bool get useDefaultMaxHp;
  @FlutterAlignmentConverter()
  Alignment get photoAlignment;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $CharacterSettingsCopyWith<CharacterSettings> get copyWith;
}

/// @nodoc
abstract class $CharacterSettingsCopyWith<$Res> {
  factory $CharacterSettingsCopyWith(
          CharacterSettings value, $Res Function(CharacterSettings) then) =
      _$CharacterSettingsCopyWithImpl<$Res>;
  $Res call(
      {bool useDefaultMaxHp,
      @FlutterAlignmentConverter() Alignment photoAlignment});
}

/// @nodoc
class _$CharacterSettingsCopyWithImpl<$Res>
    implements $CharacterSettingsCopyWith<$Res> {
  _$CharacterSettingsCopyWithImpl(this._value, this._then);

  final CharacterSettings _value;
  // ignore: unused_field
  final $Res Function(CharacterSettings) _then;

  @override
  $Res call({
    Object useDefaultMaxHp = freezed,
    Object photoAlignment = freezed,
  }) {
    return _then(_value.copyWith(
      useDefaultMaxHp: useDefaultMaxHp == freezed
          ? _value.useDefaultMaxHp
          : useDefaultMaxHp as bool,
      photoAlignment: photoAlignment == freezed
          ? _value.photoAlignment
          : photoAlignment as Alignment,
    ));
  }
}

/// @nodoc
abstract class _$CharacterSettingsCopyWith<$Res>
    implements $CharacterSettingsCopyWith<$Res> {
  factory _$CharacterSettingsCopyWith(
          _CharacterSettings value, $Res Function(_CharacterSettings) then) =
      __$CharacterSettingsCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool useDefaultMaxHp,
      @FlutterAlignmentConverter() Alignment photoAlignment});
}

/// @nodoc
class __$CharacterSettingsCopyWithImpl<$Res>
    extends _$CharacterSettingsCopyWithImpl<$Res>
    implements _$CharacterSettingsCopyWith<$Res> {
  __$CharacterSettingsCopyWithImpl(
      _CharacterSettings _value, $Res Function(_CharacterSettings) _then)
      : super(_value, (v) => _then(v as _CharacterSettings));

  @override
  _CharacterSettings get _value => super._value as _CharacterSettings;

  @override
  $Res call({
    Object useDefaultMaxHp = freezed,
    Object photoAlignment = freezed,
  }) {
    return _then(_CharacterSettings(
      useDefaultMaxHp: useDefaultMaxHp == freezed
          ? _value.useDefaultMaxHp
          : useDefaultMaxHp as bool,
      photoAlignment: photoAlignment == freezed
          ? _value.photoAlignment
          : photoAlignment as Alignment,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_CharacterSettings extends _CharacterSettings {
  const _$_CharacterSettings(
      {this.useDefaultMaxHp = true,
      @FlutterAlignmentConverter() this.photoAlignment})
      : assert(useDefaultMaxHp != null),
        super._();

  factory _$_CharacterSettings.fromJson(Map<String, dynamic> json) =>
      _$_$_CharacterSettingsFromJson(json);

  @JsonKey(defaultValue: true)
  @override
  final bool useDefaultMaxHp;
  @override
  @FlutterAlignmentConverter()
  final Alignment photoAlignment;

  @override
  String toString() {
    return 'CharacterSettings(useDefaultMaxHp: $useDefaultMaxHp, photoAlignment: $photoAlignment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CharacterSettings &&
            (identical(other.useDefaultMaxHp, useDefaultMaxHp) ||
                const DeepCollectionEquality()
                    .equals(other.useDefaultMaxHp, useDefaultMaxHp)) &&
            (identical(other.photoAlignment, photoAlignment) ||
                const DeepCollectionEquality()
                    .equals(other.photoAlignment, photoAlignment)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(useDefaultMaxHp) ^
      const DeepCollectionEquality().hash(photoAlignment);

  @JsonKey(ignore: true)
  @override
  _$CharacterSettingsCopyWith<_CharacterSettings> get copyWith =>
      __$CharacterSettingsCopyWithImpl<_CharacterSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CharacterSettingsToJson(this);
  }
}

abstract class _CharacterSettings extends CharacterSettings {
  const _CharacterSettings._() : super._();
  const factory _CharacterSettings(
          {bool useDefaultMaxHp,
          @FlutterAlignmentConverter() Alignment photoAlignment}) =
      _$_CharacterSettings;

  factory _CharacterSettings.fromJson(Map<String, dynamic> json) =
      _$_CharacterSettings.fromJson;

  @override
  bool get useDefaultMaxHp;
  @override
  @FlutterAlignmentConverter()
  Alignment get photoAlignment;
  @override
  @JsonKey(ignore: true)
  _$CharacterSettingsCopyWith<_CharacterSettings> get copyWith;
}
