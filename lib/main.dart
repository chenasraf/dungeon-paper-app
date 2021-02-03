import 'dart:async';
import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/flutter_utils/on_init_caller.dart';
import 'package:dungeon_paper/src/pages/about_view/about_view.dart';
import 'package:dungeon_paper/src/pages/account_view/account_view.dart';
import 'package:dungeon_paper/src/pages/backup_view/backup_view.dart';
import 'package:dungeon_paper/src/pages/character/select_race_move_view.dart';
import 'package:dungeon_paper/src/pages/custom_classes_view/custom_classes_view.dart';
import 'package:dungeon_paper/src/pages/character/character_view.dart';
import 'package:dungeon_paper/src/pages/scaffold/main_view.dart';
import 'package:dungeon_paper/src/controllers/prefs_controller.dart';
import 'package:dungeon_paper/src/pages/settings_view/settings_view.dart';
import 'package:dungeon_paper/src/scaffolds/inventory_item_view.dart';
import 'package:dungeon_paper/src/scaffolds/move_view.dart';
import 'package:dungeon_paper/src/scaffolds/race_move_view.dart';
import 'package:dungeon_paper/src/scaffolds/spell_view.dart';
import 'package:dungeon_paper/src/scaffolds/custom_class_wizard/custom_class_view.dart';
import 'package:dungeon_paper/src/scaffolds/note_view.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/error_reporting.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';

import 'themes/themes.dart';

void withInit(Function() cb) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    Themes.init();
    if (!kIsWeb) {
      unawaited(initErrorReporting());
    }
    runZonedGuarded(cb, reportError);
  } catch (e) {
    logger.e(e);
    rethrow;
  }
}

void main() async {
  await initApp(web: kIsWeb);
  withInit(() {
    prefsController.loadAll();
    runApp(DungeonPaper());
  });
}

class DungeonPaper extends StatelessWidget {
  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return OnInitCaller(
      onInit: () => analytics.logAppOpen(),
      child: GetMaterialApp(
        title: 'Dungeon Paper',
        theme: Themes.currentTheme,
        routes: {
          Routes.home: (ctx) => MainContainer(),
          Routes.account: (ctx) => AccountView(),
          Routes.settings: (ctx) => SettingsView(),
          Routes.backup: (ctx) => BackupView(),
          Routes.customClassesList: (ctx) => CustomClassesView(),
          Routes.customClassCreate: (ctx) =>
              CustomClassView(mode: DialogMode.create),
          Routes.customClassEdit: (ctx) {
            final CustomClassViewArguments arguments = Get.arguments;
            return CustomClassView(
              mode: DialogMode.edit,
              customClass: arguments.customClass,
              onSave: arguments.onSave,
            );
          },
          Routes.characterCreate: (ctx) => CharacterView(
                character: null,
                mode: DialogMode.create,
              ),
          Routes.characterEdit: (ctx) {
            final CharacterViewArguments arguments = Get.arguments;
            return CharacterView(
              character: arguments.character,
              mode: DialogMode.edit,
              onSave: arguments.onSave,
            );
          },
          Routes.moveAdd: (ctx) => MoveView.createForCharacter(
                character: characterController.current,
              ),
          Routes.moveEdit: (ctx) {
            final MoveViewArguments arguments = Get.arguments;
            return MoveView(
              mode: DialogMode.edit,
              move: arguments.move,
              onSave: arguments.onSave,
            );
          },
          Routes.raceMoveAdd: (ctx) {
            final RaceMoveViewArguments arguments = Get.arguments;
            return RaceMoveView(
              mode: DialogMode.create,
              move: arguments.move,
              onSave: arguments.onSave,
            );
          },
          Routes.raceMoveEdit: (ctx) {
            final SelectRaceMoveViewArguments arguments = Get.arguments;
            return SelectRaceMoveView(
              mode: DialogMode.edit,
              character: arguments.character,
              onUpdate: arguments.onUpdate,
            );
          },
          Routes.spellAdd: (ctx) => SpellView.createForCharacter(
                character: characterController.current,
              ),
          Routes.spellEdit: (ctx) {
            final SpellViewArguments arguments = Get.arguments;
            return SpellView(
              mode: DialogMode.edit,
              onSave: arguments.onSave,
              spell: arguments.spell,
            );
          },
          Routes.itemAdd: (ctx) => InventoryItemView.createForCharacter(
                character: characterController.current,
              ),
          Routes.itemEdit: (ctx) {
            final InventoryItemViewArguments arguments = Get.arguments;
            return InventoryItemView(
              character: characterController.current,
              item: arguments.item,
              mode: DialogMode.edit,
              onSave: arguments.onSave,
            );
          },
          Routes.noteAdd: (ctx) => NoteView.createForCharacter(
                character: characterController.current,
              ),
          Routes.noteEdit: (ctx) {
            final NoteViewArguments arguments = Get.arguments;
            return NoteView(
              categories: arguments.categories,
              mode: DialogMode.edit,
              note: arguments.note,
              onSave: arguments.onSave,
            );
          },
          Routes.about: (ctx) => AboutView(),
        },
        navigatorObservers: [observer],
      ),
    );
  }
}
