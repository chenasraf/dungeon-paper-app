import 'package:dungeon_paper/db/models/prefs_settings.dart';
import 'package:dungeon_paper/src/controllers/auth_controller.dart';
import 'package:dungeon_paper/src/utils/auth/auth.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKeys {
  userEmail,
  userId,
  characterId,
  lastOpenedVersion,
}

Map<SharedPrefKeys, String> sharedPrefsKeyMap = {
  SharedPrefKeys.characterId: 'characterId',
  SharedPrefKeys.userId: 'userId',
  SharedPrefKeys.userEmail: 'userEmail',
};

void withPrefs(Function(SharedPreferences inst) fn) =>
    SharedPreferences.getInstance().then(fn);

class PrefsStore extends GetxController {
  final _user = UserDetails().obs;
  final _settings = PrefsSettings().obs;
  final _prefs = Rx<SharedPreferences>();
  final _config = RxMap<String, RemoteConfigValue>();

  PrefsStore._() {
    withPrefs((inst) => _prefs.value = inst);
  }

  UserDetails get user => _user.value;
  PrefsSettings get settings => _settings.value;
  Map<String, RemoteConfigValue> get config => _config;

  void setUser(UserDetails user, [bool updateCondition = true]) {
    _user.value = user;
    update(null, updateCondition);
  }

  void updateSettings(PrefsSettings settings, [bool updateCondition = true]) {
    _settings.value = settings;
    settings.applyAllSettings();
    update(null, updateCondition);
  }

  String _getStr(SharedPrefKeys key) {
    final prefs = _prefs.value;
    try {
      if (prefs.containsKey(sharedPrefsKeyMap[key])) {
        return prefs.getString(sharedPrefsKeyMap[key]);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> loadAll([bool updateCondition = true]) async {
    final prefs = _prefs.value;
    user.setId(_getStr(SharedPrefKeys.userId), false);
    user.setEmail(_getStr(SharedPrefKeys.userEmail), false);
    user.setLastCharacterId(_getStr(SharedPrefKeys.characterId), false);
    prefsController.updateSettings(PrefsSettings.loadFromPrefs(prefs), false);
    await _autoSignIn();
    update(null, updateCondition);
  }

  static Future _autoSignIn() async {
    authController.requestLogin();
    try {
      var user = await signInAutomatically();
      if (user == null) {
        throw SignInError('no_silent_login');
      }
    } on SignInError {
      authController.noLogin();
      logger.d('Silent login failed');
    } catch (e) {
      authController.noLogin();
      logger.d('Silent login unexpected error:');
      rethrow;
    }
  }

  void setConfig(Map<String, RemoteConfigValue> all,
      [bool updateCondition = true]) {
    _config.clear();
    _config.addAll(all);
    update(null, updateCondition);
  }
}

class UserDetails extends GetxController {
  final _email = RxString();
  final _id = RxString();
  final _lastCharacterId = RxString();

  String get id => _id.value;
  String get email => _email.value;
  String get lastCharacterId => _lastCharacterId.value;

  void setId(String value, [bool updateCondition = true]) {
    _id.value = value;
    withPrefs(
      (prefs) => prefs.setString(
        sharedPrefsKeyMap[SharedPrefKeys.userId],
        value,
      ),
    );
    update(null, updateCondition);
  }

  void setEmail(String value, [bool updateCondition = true]) {
    _email.value = value;
    withPrefs(
      (prefs) => prefs.setString(
        sharedPrefsKeyMap[SharedPrefKeys.userEmail],
        value,
      ),
    );
    update(null, updateCondition);
  }

  void setLastCharacterId(String value, [bool updateCondition = true]) {
    _lastCharacterId.value = value;
    withPrefs(
      (prefs) => prefs.setString(
        sharedPrefsKeyMap[SharedPrefKeys.characterId],
        value,
      ),
    );
    update(null, updateCondition);
  }
}

final prefsController = PrefsStore._();
