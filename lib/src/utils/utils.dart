import 'dart:convert';
import 'dart:math';
import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_world_data/dw_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

String capitalize(String string, [String sep = ' ']) {
  return string.splitMapJoin(RegExp(sep),
      onMatch: (s) =>
          s.input[s.start].toUpperCase() +
          s.input.substring(s.start + 1, s.end),
      onNonMatch: (s) =>
          s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s);
}

String pluralize(
  num amount,
  String str, {
  String plural = '{}s',
  Map<String, String> specificAmounts = const {},
}) {
  if (specificAmounts.containsKey(amount)) {
    return specificAmounts[amount];
  }
  if (amount == 1) {
    return '$amount $str';
  }
  var _plural = plural.replaceAll('{}', str);
  return '$amount $_plural';
}

T noopReturn<T>(T a) => a;
void noopVoid<T>(T a) {}

T numAs<T extends num>(num number) => number == double.infinity
    ? double.infinity
    : T == double
        ? number.toDouble()
        : number.toInt();

T clamp<T extends num>(num number, num low, num high) => max<T>(
      numAs<T>(low),
      min<T>(numAs<T>(number), numAs<T>(high)),
    );

double lerp(num t, num minA, num maxA, num minB, num maxB) =>
    (t - minA) / (maxA - minA) * (maxB - minB) + minB;

T clamp01<T extends num>(T number) => clamp<T>(number, 0, 1);

double lerp01(num t, num minA, num maxA) => lerp(t, minA, maxA, 0, 1);

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s.toString()) != null;
}

Type typeOf<T>() => T;

String enumName(Object o) {
  var text = o.toString();
  return text.substring(text.indexOf('.') + 1);
}

E Function(dynamic k) stringToEnumPredicate<E>(Map<String, E> map) {
  return (k) => k is E
      ? k
      : k is String && map.containsKey(k)
          ? map[k]
          : throw ('No corresponding enum value');
}

E stringToEnum<E>(dynamic key, Map<String, E> map) {
  return stringToEnumPredicate(map)(key);
}

typedef ReturnPredicate<T> = bool Function(T ret) Function(T par);
typedef InputPredicate<T> = bool Function(T par, T par2);

ReturnPredicate<T> matcher<T>(InputPredicate<T> predicate) =>
    (T orig) => (T i) => predicate(i, orig);

// (Note note) => (Note n) => n.key != null && n.key == note.key || n.title == note.title;

String currency(num amt) {
  return commatize(amt).replaceAll(RegExp(r'\.0+$'), '') + ' G';
}

String commatize(num number, [num precision = 2]) {
  return number
      .toStringAsFixed(precision)
      .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')
      .replaceFirst(RegExp(r'\.0+$'), '');
}

class BgAndFgColors {
  final Color background;
  final Color foreground;

  BgAndFgColors(this.background, this.foreground);
}

Secrets _secrets;

class Secrets {
  final Map<String, dynamic> _data;
  Secrets(Map<String, dynamic> data) : _data = data;

  String get SENTRY_DSN => _data['SENTRY_DSN'];
  String get PAYPAL_DONATE_URL => _data['PAYPAL_DONATE_URL'];
  String get FEEDBACK_EMAIL => _data['FEEDBACK_EMAIL'];
  String get GITHUB_CHANGELOG_URL => _data['GITHUB_CHANGELOG_URL'];
  String get API_DOMAIN => _data['API_DOMAIN'];
  String get API_PATH => _data['API_PATH'];
  String get GOOGLE_CLIENT_ID => _data['GOOGLE_CLIENT_ID'];
  String get VERSION_NUMBER => _data['VERSION_NUMBER'];
  String get ANDROID_APP_URL => _data['ANDROID_APP_URL'];

  dynamic operator [](String key) {
    return _data[key];
  }

  @override
  String toString() => _data
      // .map((key, value) => MapEntry(key, '*' * value.toString().length))
      .toString();
}

Future<Secrets> loadSecrets() async {
  if (_secrets == null) {
    _secrets = Secrets(jsonDecode(await rootBundle.loadString('secrets.json')));
    if (isInDebugMode) logger.d('Loaded secrets: $_secrets');
  }
  return _secrets;
}

bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

R Function() pass1<T, R>(R Function(T a) a, T b) =>
    a != null ? () => a(b) : null;

Map<V, K> invertMap<K, V>(Map<K, V> map) {
  return map.map((k, v) => MapEntry(v, k));
}

class Enumeration<T> {
  final int index;
  final T value;

  Enumeration(this.index, this.value);

  int get i => index;
  T get v => value;
}

Iterable<Enumeration<T>> enumerate<T>(Iterable<T> items) sync* {
  var idx = 0;
  for (var item in items) {
    yield Enumeration(idx++, item);
  }
}

bool Function(T) keyMatcher<T>(dynamic Function(T) delegate, T object) =>
    (compare) => delegate(object) == delegate(compare);

bool Function(DWEntity) dwEntityMatcher(DWEntity comp) =>
    keyMatcher((o) => o.key, comp);

bool Function(KeyMixin) keyMixinMatcher(KeyMixin comp) =>
    keyMatcher((o) => o.key, comp);

bool Function(T) getMatcher<T>(T obj, [bool Function(T) defaultMatcher]) =>
    obj is DWEntity
        ? dwEntityMatcher(obj)
        : obj is KeyMixin
            ? keyMixinMatcher(obj)
            : defaultMatcher ?? (o) => o == obj;

List<T> findAndReplaceInList<T>(List<T> list, T obj,
    [bool Function(T) matcher]) {
  num index = list.indexWhere(getMatcher(obj, matcher));
  return List<T>.from(list)
    ..[index] = obj
    ..removeWhere((element) => element == null);
}

List<T> upsertIntoList<T>(List<T> list, T obj, [bool Function(T) matcher]) {
  num index = list.indexWhere(getMatcher(obj, matcher));
  if (index == -1) {
    return addToList(list, obj);
  }
  return findAndReplaceInList(list, obj, matcher);
}

List<T> removeFromList<T>(List<T> list, T obj, [bool Function(T) matcher]) =>
    List.from(list)
      ..removeWhere(getMatcher(obj, matcher))
      ..removeWhere((element) => element == null);

List<T> addToList<T>(List<T> list, T item) => List.from(list)
  ..add(item)
  ..removeWhere((element) => element == null);

String camelToSnake(String string) => string?.isNotEmpty == true
    ? string[0].toLowerCase() +
        string.substring(1).replaceAllMapped(
              RegExp(r'[A-Z0-9]+'),
              (match) => '_' + match.group(0).toLowerCase(),
            )
    : '';

String snakeToCamel(String string) =>
    string[0] +
    string.substring(1).replaceAllMapped(
          RegExp(r'_([a-zA-Z0-9])'),
          (match) => match.group(1).toUpperCase(),
        );

Map<K, List<V>> groupByAlt<K, V>(Iterable<V> list, K Function(V) predicate) =>
    groupBy(list, predicate);

Map<K, List<V>> groupBy<K, V>(Iterable<V> list, K Function(V) predicate) {
  final out = <K, List<V>>{};
  for (final item in list) {
    final k = predicate(item);
    out[k] ??= <V>[];
    out[k].add(item);
  }
  return out;
}

V mapSwitch<K, V>(
  Map<K, V> map,
  K value, {
  V defaultValue,
}) {
  for (final iter in map.entries) {
    if (iter.key == value) {
      return iter.value;
    }
  }

  return defaultValue;
}

Set<T> unique<T>(Iterable<T> list, dynamic Function(T) value) {
  final reversed = list.toList().reversed.toList();
  final values = list.map(value).toSet();
  return Set.from(reversed..retainWhere((x) => values.remove(value(x))));
}

String prettyDouble(num number) =>
    number == number.ceil() ? number.toStringAsFixed(0) : number.toString();

Map<K, V> pick<K, V>(Map<K, V> map, Iterable<String> keys) {
  if (keys == null) {
    return {...map};
  }

  return <K, V>{
    for (final entry in map.entries)
      if (keys.contains(entry.key)) entry.key: entry.value,
  };
}
