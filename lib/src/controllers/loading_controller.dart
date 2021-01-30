import 'package:get/get.dart';

enum LoadingKeys {
  user,
  character,
  customClasses,
}

class LoadingController extends GetxController {
  final RxMap<LoadingKeys, bool> _data = <LoadingKeys, bool>{
    LoadingKeys.user: true,
    LoadingKeys.character: true,
  }.obs;

  bool operator [](key) {
    if (key is! LoadingKeys) {
      throw FormatException(
          'Expected LoadingKeys, ${key.runtimeType} given', key, 0);
    }

    return _data[key] == true;
  }

  void requestLogin([bool updateCondition = true]) {
    _data[LoadingKeys.character] = true;
    _data[LoadingKeys.user] = true;
    update(null, updateCondition);
  }

  void login([bool updateCondition = true]) {
    _data[LoadingKeys.user] = false;
    update(null, updateCondition);
  }

  void noLogin([bool updateCondition = true]) {
    _data[LoadingKeys.character] = false;
    _data[LoadingKeys.user] = false;
    update(null, updateCondition);
  }

  void upsertCharacter([bool updateCondition = true]) {
    _data[LoadingKeys.character] = false;
    update(null, updateCondition);
  }

  void setUser([bool updateCondition = true]) {
    _data[LoadingKeys.user] = false;
    update(null, updateCondition);
  }

  void getCustomClasses([bool updateCondition = true]) {
    _data[LoadingKeys.customClasses] = true;
    update(null, updateCondition);
  }

  void setCustomClasses([bool updateCondition = true]) {
    _data[LoadingKeys.customClasses] = false;
    update(null, updateCondition);
  }
}

final loadingController = LoadingController();
