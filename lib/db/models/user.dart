import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/models/converters/datetime_converter.dart';
import 'package:dungeon_paper/db/models/converters/document_reference_converter.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/utils/auth/auth.dart';
import 'package:dungeon_paper/src/utils/logger.dart';

import 'character.dart';
import 'custom_class.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with FirebaseMixin implements _$User {
  const User._();

  @With(FirebaseMixin)
  const factory User({
    @required String displayName,
    @required String email,
    String photoURL,
    @Default({}) Map<String, dynamic> features,
    @DocumentReferenceConverter() DocumentReference ref,
    @DateTimeConverter() DateTime createdAt,
    @DateTimeConverter() DateTime updatedAt,
    String lastCharacterId,
  }) = _User;

  factory User.fromJson(json, {DocumentReference ref}) =>
      _$UserFromJson(json).copyWith(ref: ref);

  bool hasFeature(String key) =>
      key != null &&
      features.containsKey(key) &&
      features[key] != false &&
      features[key] != null;

  bool featureEnabled(String key) =>
      features[key] is bool && features[key] == true;

  bool get isDm => featureEnabled('dm_tools_preview');

  bool get isTester => hasFeature('tester');

  Future<Character> createCharacter(Character character) async {
    var doc = ref.collection('characters').doc();
    var data = character.toJson();
    logger.d('Creating character: $data');
    await doc.set(data);
    character = character.copyWith(ref: doc);
    characterController.upsert(character);
    return character;
  }

  Future<CustomClass> createCustomClass(CustomClass cls) async {
    var doc = ref.collection('custom_classes').doc();
    var data = cls.toJson();
    logger.d('Creating custom class: $data');
    await doc.set(data);
    cls = cls.copyWith(ref: doc);
    customClassesController.upsert(cls);
    return cls;
  }

  Future<User> changeEmail(String newEmail) async {
    final newRef = await move(
      'user_data/$newEmail',
      update: {
        'email': newEmail,
      },
    );
    await updateFirebaseEmail(newEmail);
    return copyWith(
      email: newEmail,
      ref: newRef,
    );
  }
}
