import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:get/get.dart';

class CustomClassesController extends GetxController {
  final RxMap<String, CustomClass> _classes = <String, CustomClass>{}.obs;

  Map<String, CustomClass> get classes => _classes;

  void upsert(CustomClass cls, [bool updateCondition = true]) {
    classes[cls.documentID] = cls;
    update(null, updateCondition);
  }

  void remove(CustomClass cls, [bool updateCondition = true]) {
    classes.remove(cls.documentID);
    update(null, updateCondition);
  }

  void setAll(Iterable<CustomClass> classes, [bool updateCondition = true]) {
    clear(false);
    _classes.assignAll({
      for (final cls in classes) cls.documentID: cls,
    });
    update(null, updateCondition);
  }

  void clear([bool updateCondition = true]) {
    _classes.removeWhere((_, __) => true);
    update(null, updateCondition);
  }
}

final customClassesController = CustomClassesController();
