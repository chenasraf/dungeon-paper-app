import 'package:dungeon_paper/src/controllers/loading_controller.dart';
import 'package:dungeon_paper/src/controllers/prefs_controller.dart';
import 'package:get/get.dart';
import 'package:dungeon_paper/db/models/character.dart';

class CharacterController extends GetxController {
  final Rx<Character> _current = Rx();
  final RxMap<String, Character> _all = <String, Character>{}.obs;

  Character get current => _current.value;

  Map<String, Character> get all {
    final list = _all.values.toList();
    list.sort((a, b) => a.order - b.order);

    return Map.fromIterable(
      list,
      key: (char) => (char as Character).documentID,
    );
  }

  void setCurrent(Character value, [bool updateCondition = true]) {
    _current.value = value ?? _all[current.documentID] ?? _all.values.first;
    prefsController.user.setLastCharacterId(current.documentID, false);
    update(null, updateCondition);
  }

  void upsert(Character character, [bool updateCondition = true]) {
    _all[character.documentID] = character;
    if (current.documentID == character.documentID) {
      _current.value = character;
    }
    update(null, updateCondition);
  }

  void remove(Character character) {
    _all.removeWhere((key, value) => character.documentID == value.documentID);
    if (current.documentID == character.documentID) {
      _current.value = _all.values.first;
    }
    update();
  }

  void setAll(Iterable<Character> characters, [bool updateCondition = true]) {
    final currentDocId = current?.documentID;
    clear(false);
    _all.assignAll({
      for (final char in characters) char.documentID: char,
    });
    setCurrent(
      currentDocId != null
          ? _all.values.firstWhere(
              (c) => c.documentID == currentDocId,
              orElse: () =>
                  _all[prefsController.user.lastCharacterId] ??
                  characters.first,
            )
          : _all[prefsController.user.lastCharacterId] ?? characters.first,
      false,
    );
    loadingController.upsertCharacter(false);
    update(null, updateCondition);
  }

  void clear([bool updateCondition = true]) {
    _current.value = null;
    _all.removeWhere((_, __) => true);
    update(null, updateCondition);
  }
}

final characterController = CharacterController();

// ignore: missing_return
CharacterController characterReducer(CharacterController state, action) {
  // state._all.assignAll({});

  // if (action is SetCharacters) {
  //   state._all.assignAll(action.characters);

  //   if (state.current != null) {
  //     state.current = action.characters[state.current.documentID];
  //   } else if (action.characters.isNotEmpty &&
  //       !state._all.containsKey(state.current?.documentID)) {
  //     state.current = action.characters.values.first;
  //   }
  //   return state;
  // }

  // if (action is RemoveCharacter) {
  //   state._all.removeWhere((k, v) => k == action.character.documentID);
  //   if (state.current.documentID == action.character.documentID) {
  //     state.current = state._all.values.first;
  //   }
  //   return state;
  // }

  // if (action is UpsertCharacter) {
  //   state._all[action.character.documentID] = action.character;
  //   if (state.current?.documentID == action.character.documentID) {
  //     state.current = action.character;
  //   }
  //   return state;
  // }

  // if (action is SetCurrentChar) {
  //   state.current = action.character;
  //   return state;
  // }

  // if (action is ClearCharacters) {
  //   return CharacterController();
  // }

  // return state;
}
