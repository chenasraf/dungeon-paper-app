import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:dungeon_paper/db/models/user.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/controllers/loading_controller.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get/get.dart';

class AuthController extends GetxController {
  void requestLogin() {
    loadingController.requestLogin();
    userController.clear();
    update();
  }

  void login({
    User user,
    fb.User firebaseUser,
    bool updateCondition = true,
  }) {
    loadingController.login(false);
    userController.login(user: user, firebaseUser: firebaseUser);
    update(null, updateCondition);
  }

  void noLogin([bool updateCondition = true]) {
    loadingController.noLogin(false);
    userController.clear(false);
    characterController.clear(false);
    update(null, updateCondition);
  }

  void upsertCharacter(Character character, [bool updateCondition = true]) {
    loadingController.upsertCharacter(false);
    characterController.upsert(character, false);
    update(null, updateCondition);
  }

  void setUser(User user, [bool updateCondition = true]) {
    loadingController.setUser(false);
    userController.setCurrent(user, false);
    update(null, updateCondition);
  }

  void getCustomClasses([bool updateCondition = true]) {
    loadingController.getCustomClasses(false);
    customClassesController.clear();
    update(null, updateCondition);
  }

  void setCustomClasses(Iterable<CustomClass> classes,
      [bool updateCondition = true]) {
    loadingController.setCustomClasses(false);
    customClassesController.setAll(classes, false);
    update(null, updateCondition);
  }

  void setFirebaseUser(fb.User user, [bool updateCondition = true]) {
    userController.setFirebaseUser(user, false);
    update(null, updateCondition);
  }

  void logout([bool updateCondition = true]) {
    noLogin(false);
    update(null, updateCondition);
  }
}

final authController = AuthController();
