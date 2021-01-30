// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Note _$NoteFromJson(Map<String, dynamic> json) {
  return _Note.fromJson(json);
}

/// @nodoc
class _$NoteTearOff {
  const _$NoteTearOff();

// ignore: unused_element
  _Note call(
      {String category = 'Misc',
      @required @DefaultUuid() String key,
      @required String title,
      String description = '',
      @TagConverter() List<Tag> tags = const []}) {
    return _Note(
      category: category,
      key: key,
      title: title,
      description: description,
      tags: tags,
    );
  }

// ignore: unused_element
  Note fromJson(Map<String, Object> json) {
    return Note.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Note = _$NoteTearOff();

/// @nodoc
mixin _$Note {
  String get category;
  @DefaultUuid()
  String get key;
  String get title;
  String get description;
  @TagConverter()
  List<Tag> get tags;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $NoteCopyWith<Note> get copyWith;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res>;
  $Res call(
      {String category,
      @DefaultUuid() String key,
      String title,
      String description,
      @TagConverter() List<Tag> tags});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res> implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  final Note _value;
  // ignore: unused_field
  final $Res Function(Note) _then;

  @override
  $Res call({
    Object category = freezed,
    Object key = freezed,
    Object title = freezed,
    Object description = freezed,
    Object tags = freezed,
  }) {
    return _then(_value.copyWith(
      category: category == freezed ? _value.category : category as String,
      key: key == freezed ? _value.key : key as String,
      title: title == freezed ? _value.title : title as String,
      description:
          description == freezed ? _value.description : description as String,
      tags: tags == freezed ? _value.tags : tags as List<Tag>,
    ));
  }
}

/// @nodoc
abstract class _$NoteCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$NoteCopyWith(_Note value, $Res Function(_Note) then) =
      __$NoteCopyWithImpl<$Res>;
  @override
  $Res call(
      {String category,
      @DefaultUuid() String key,
      String title,
      String description,
      @TagConverter() List<Tag> tags});
}

/// @nodoc
class __$NoteCopyWithImpl<$Res> extends _$NoteCopyWithImpl<$Res>
    implements _$NoteCopyWith<$Res> {
  __$NoteCopyWithImpl(_Note _value, $Res Function(_Note) _then)
      : super(_value, (v) => _then(v as _Note));

  @override
  _Note get _value => super._value as _Note;

  @override
  $Res call({
    Object category = freezed,
    Object key = freezed,
    Object title = freezed,
    Object description = freezed,
    Object tags = freezed,
  }) {
    return _then(_Note(
      category: category == freezed ? _value.category : category as String,
      key: key == freezed ? _value.key : key as String,
      title: title == freezed ? _value.title : title as String,
      description:
          description == freezed ? _value.description : description as String,
      tags: tags == freezed ? _value.tags : tags as List<Tag>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Note extends _Note {
  const _$_Note(
      {this.category = 'Misc',
      @required @DefaultUuid() this.key,
      @required this.title,
      this.description = '',
      @TagConverter() this.tags = const []})
      : assert(category != null),
        assert(key != null),
        assert(title != null),
        assert(description != null),
        assert(tags != null),
        super._();

  factory _$_Note.fromJson(Map<String, dynamic> json) =>
      _$_$_NoteFromJson(json);

  @JsonKey(defaultValue: 'Misc')
  @override
  final String category;
  @override
  @DefaultUuid()
  final String key;
  @override
  final String title;
  @JsonKey(defaultValue: '')
  @override
  final String description;
  @JsonKey(defaultValue: const [])
  @override
  @TagConverter()
  final List<Tag> tags;

  @override
  String toString() {
    return 'Note(category: $category, key: $key, title: $title, description: $description, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Note &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)) &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.tags, tags) ||
                const DeepCollectionEquality().equals(other.tags, tags)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(tags);

  @JsonKey(ignore: true)
  @override
  _$NoteCopyWith<_Note> get copyWith =>
      __$NoteCopyWithImpl<_Note>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_NoteToJson(this);
  }
}

abstract class _Note extends Note {
  const _Note._() : super._();
  const factory _Note(
      {String category,
      @required @DefaultUuid() String key,
      @required String title,
      String description,
      @TagConverter() List<Tag> tags}) = _$_Note;

  factory _Note.fromJson(Map<String, dynamic> json) = _$_Note.fromJson;

  @override
  String get category;
  @override
  @DefaultUuid()
  String get key;
  @override
  String get title;
  @override
  String get description;
  @override
  @TagConverter()
  List<Tag> get tags;
  @override
  @JsonKey(ignore: true)
  _$NoteCopyWith<_Note> get copyWith;
}
