import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_world_data/player_class.dart';

Future<DocumentReference> cerateCustomClass(PlayerClass playerClass) async {
  var json = playerClass.toJSON();
  var userDocId = userController.currentUserDocID;
  var doc = firestore.collection('custom_classes/${userDocId}').doc();
  await doc.set(json);
  return doc;
}

Future<DocumentReference> updateCustomClass(
    String docId, PlayerClass playerClass) async {
  var json = playerClass.toJSON();
  var userDocId = userController.currentUserDocID;
  var doc = firestore.collection('custom_classes/${userDocId}').doc(docId);
  await doc.update(json);
  return doc;
}

Future<List<DocumentSnapshot>> getCustomClasses() async {
  var userDocId = userController.currentUserDocID;
  var docs = await firestore.collection('custom_classes/${userDocId}').get();
  return docs.docs;
}
