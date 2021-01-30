import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:dungeon_paper/src/atoms/empty_state.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/lists/custom_classes_list.dart';
import 'package:dungeon_paper/src/lists/player_class_list.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/scaffolds/custom_class_wizard/custom_class_view.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';

class CustomClassesView extends StatefulWidget {
  @override
  _CustomClassesViewState createState() => _CustomClassesViewState();
}

class _CustomClassesViewState extends State<CustomClassesView> {
  @override
  void initState() {
    super.initState();
    logger.d('Page View: ${ScreenNames.CustomClasses}');
    analytics.setCurrentScreen(screenName: ScreenNames.CustomClasses);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final hasClasses = customClassesController.classes.isNotEmpty;
        return MainScaffold(
          title: Text('Custom Classes'),
          automaticallyImplyLeading: true,
          useElevation: false,
          elevation: 0,
          actions: [
            PlayerClassList(
              builder: (context, list) => PopupMenuButton<PlayerClass>(
                icon: Icon(Icons.content_copy),
                tooltip: 'Copy existing class',
                onSelected: _copyExisting,
                itemBuilder: (context) => [
                  PopupMenuItem<PlayerClass>(
                    value: null,
                    enabled: false,
                    child: Text('Copy existing class:'),
                  ),
                  ...list.map(
                    (el) => PopupMenuItem<PlayerClass>(
                      value: el,
                      child: Text(el.name),
                    ),
                  ),
                ],
              ),
            ),
          ],
          wrapWithScrollable: hasClasses,
          body: hasClasses
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomClassesList(
                    onEdit: _edit(context),
                    onDelete: _delete(context),
                  ),
                )
              : Center(
                  child: EmptyState(
                    title: Text('You have no custom classes'),
                    subtitle: Text("Start by tapping the '+' button"),
                    image: Icon(Icons.person, size: 80),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Get.theme.colorScheme.background,
            foregroundColor: Get.theme.colorScheme.onBackground,
            onPressed: _add(context),
          ),
        );
      },
    );
  }

  void Function() _add(BuildContext context) {
    return () {
      Get.toNamed('/create-custom-class');
    };
  }

  void Function(CustomClass) _edit(BuildContext context) {
    return (cls) {
      Get.toNamed(
        '/edit-custom-class',
        arguments: CustomClassViewArguments(
          customClass: cls,
        ),
      );
    };
  }

  Future<void> Function(CustomClass) _delete(BuildContext context) {
    return (cls) async {
      if (await showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: Text('Are you sure you want to delete this class?'),
              text: Text(
                  "Don't worry, your characters using this class wil not be affected."),
            ),
          ) ==
          true) {
        unawaited(cls.delete());
      }
    };
  }

  void _copyExisting(PlayerClass cls) {
    var custCls = CustomClass.fromPlayerClass(cls).copyWith(
      name: cls.name + ' copy',
    );

    Get.toNamed(
      '/create-custom-class',
      arguments: CustomClassViewArguments(
        customClass: custCls,
      ),
    );
  }
}
