import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/pages/settings_view/settings_list_tile.dart';
import 'package:dungeon_paper/src/controllers/prefs_controller.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final divider = Divider(height: 1);
    return MainScaffold(
      title: Text('Dungeon Paper Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16).copyWith(top: 0),
          child: Card(
            child: Column(
              children: [
                SettingsListTile(
                  title: Text('Backup Data'),
                  subtitle: Text(
                      'Import & export characters and custom classes.\nYou can share these files with other users safely.'),
                  onTap: _openBackupView,
                ),
                // divider,
                // SettingsListTile(
                //   title: Text('Theme'),
                //   subtitle: Text(
                //       'Choose the color scheme of the app interface. '
                //       'Current: {placeholder}'),
                //   onTap: () => Get.to(ThemeSelectView()),
                // ),
                divider,
                Obx(
                  () => CheckboxSettingsListTile(
                    title: Text('Keep screen on'),
                    subtitle: Text(
                      'When checked, your screen will be prevented from turning off while the app is in the foreground.',
                    ),
                    value: prefsController.settings.keepScreenOn,
                    onChanged: (value) {
                      prefsController.updateSettings(
                        prefsController.settings.copyWith(keepScreenOn: value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openBackupView() => Get.toNamed(Routes.backup);
}
