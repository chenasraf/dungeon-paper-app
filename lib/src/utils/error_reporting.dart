import 'dart:async';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pedantic/pedantic.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final crashlytics = FirebaseCrashlytics.instance;

// Error reporting
Future<void> initErrorReporting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initCrashalytics();
}

Future<void> initCrashalytics() async {
  FlutterError.onError = (details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      crashlytics.recordFlutterError(details);
    }
  };
}

Future<void> reportError(dynamic error, StackTrace stackTrace) async {
  print('Caught error: $error');
  if (isInDebugMode) {
    print(stackTrace);
    return;
  } else {
    if (!kIsWeb) {
      unawaited(crashlytics.recordError(error, stackTrace));
    } else {
      logger.e('Uncaught error:', error, stackTrace);
    }
  }
}
