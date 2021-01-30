import 'dart:io';

import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:pedantic/pedantic.dart';

Future<String> uploadImage(
  File imageFile, {
  @required String directory,
  Map<String, String> extraMetadata,
  @required String analyticsSource,
}) async {
  unawaited(analytics
      .logEvent(name: Events.UploadCharacterAvatarAttempt, parameters: {
    'screen_name': analyticsSource,
  }));
  try {
    final fileName = basename(imageFile.path);
    final firebaseStorageRef = storage.ref().child('$directory/$fileName');
    final uploadTask = await firebaseStorageRef.putFile(
      imageFile,
      SettableMetadata(
        customMetadata: {
          'userId': userController.current.email,
          ...(extraMetadata ?? {}),
        },
      ),
    );
    final downloadURL = await uploadTask.ref.getDownloadURL();

    unawaited(
      analytics.logEvent(
        name: Events.UploadCharacterAvatarSuccess,
        parameters: {
          'screen_name': analyticsSource,
        },
      ),
    );
    return downloadURL;
  } catch (e) {
    unawaited(
      analytics.logEvent(name: Events.UploadCharacterAvatarFail, parameters: {
        'screen_name': analyticsSource,
      }),
    );
    return null;
  }
}
