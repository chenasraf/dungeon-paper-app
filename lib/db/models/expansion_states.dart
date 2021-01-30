import 'dart:convert';

import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/prefs_controller.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:pedantic/pedantic.dart';

class ExpansionStates {
  final _data = <String, Map<String, bool>>{};

  Map<String, bool> get _charData {
    _data[charId] ??= {};
    return _data[charId];
  }

  ExpansionStates([Map<String, Map<String, bool>> initialData]) {
    if (initialData != null && initialData.isNotEmpty) {
      _initData(initialData);
    }
  }

  ExpansionStates.fromData(Map<String, Map<String, bool>> initialData) {
    if (initialData != null && initialData.isNotEmpty) {
      _initData(initialData);
    }
  }

  ExpansionStates.fromPrefsString(String str) {
    if (str == null || str.isEmpty) {
      _initData({});
      return;
    }

    try {
      final orig = Map<String, String>.from(jsonDecode(str));
      final parsed = Map.fromEntries(
        orig.entries.map(
          (entry) => MapEntry(
            entry.key,
            Map<String, bool>.fromEntries(
              entry.value.split(',').map(
                    (i) => MapEntry(i, false),
                  ),
            ),
          ),
        ),
      );

      _initData(parsed);
    } catch (e) {
      logger.w(e);
      _initData({});
    }
  }

  void _initData(Map<String, Map<String, bool>> initialData) {
    _data.addAll(initialData);
  }

  bool isExpanded(String key) =>
      key == null || !_charData.containsKey(key) || _charData[key] == true;

  String get charId => characterController.current?.documentID;

  void toggle(String key) {
    if (_charData.containsKey(key)) {
      _set(key, !_charData[key]);
    } else {
      _set(key, false);
    }
  }

  void _set(String key, bool value) {
    if (key == null) {
      return;
    }
    _charData[key] = value;
    _save();
  }

  void setExpansion(String key, bool value) {
    unawaited(analytics.logEvent(
      name: Events.ToggleExpansion,
      parameters: {
        'expansion_key': key,
        'value': value,
      },
    ));
    _set(key, value);
  }

  void _save() {
    prefsController.updateSettings(
      prefsController.settings.copyWith(expansionStates: this),
    );
  }

  String toPrefsString() => jsonEncode(
        Map.fromEntries(
          _data.entries.map(
            (entry) => MapEntry(
              entry.key,
              entry.value.entries
                  .where((e) =>
                      e.key != null && e.key != 'null' && e.value == false)
                  .map((e) => e.key)
                  .join(','),
            ),
          ),
        ),
      );
}
