import 'dart:convert';
import 'dart:io';

import 'package:dungeon_paper/db/migrations/character_migrations.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/lists/character_select_list.dart';
import 'package:dungeon_paper/src/lists/custom_class_select_list.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';

class ImportView extends StatefulWidget {
  @override
  _ImportViewState createState() => _ImportViewState();
}

enum ImportFormat {
  JSON,
}

class _ImportViewState extends State<ImportView> {
  Set<Character> _charactersToImport;
  Set<CustomClass> _classesToImport;
  Set<Character> _loadedCharacters;
  Set<CustomClass> _loadedClasses;

  @override
  void initState() {
    super.initState();
    _loadedCharacters = {};
    _loadedClasses = {};
    _charactersToImport = {};
    _classesToImport = {};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Padded(
          child: Text(
            '${_loadedCharacters.isNotEmpty ? 'Select' : 'Load'} data to import',
            style: Get.theme.textTheme.headline6,
          ),
        ),
        if (_loadedCharacters.isNotEmpty)
          ExpansionTile(
            title: Text('Select characters'),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CharacterSelectList(
                  characters: _loadedCharacters,
                  selected: _charactersToImport,
                  onChange: (chars) =>
                      setState(() => _charactersToImport = chars),
                ),
              ),
            ],
          ),
        if (_loadedClasses.isNotEmpty)
          ExpansionTile(
            title: Text('Select custom classes'),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomClassSelectList(
                  classes: _loadedClasses.map((c) => c.toPlayerClass()).toSet(),
                  selected:
                      _classesToImport.map((c) => c.toPlayerClass()).toSet(),
                  onChange: (classes) => setState(() => _classesToImport =
                      classes
                          .map((c) =>
                              CustomClass.fromPlayerClass(c, retainKey: true))
                          .toSet()),
                ),
              ),
            ],
          ),
        if (_loadedCharacters.isEmpty && _loadedClasses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            child: RaisedButton.icon(
              padding: const EdgeInsets.all(8),
              label: Text('Browse...'),
              icon: Icon(Icons.folder),
              onPressed: _pickFile,
            ),
          ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: RaisedButton.icon(
              padding: const EdgeInsets.all(8),
              icon: Icon(Icons.file_download),
              label: Text(
                'Import',
                textScaleFactor: 1.5,
              ),
              onPressed:
                  _charactersToImport.isNotEmpty || _classesToImport.isNotEmpty
                      ? _confirmImport
                      : null,
            ),
          ),
        ),
      ],
    );
  }

  void _pickFile() async {
    final params = OpenFileDialogParams(
        fileExtensionsFilter: ['json'], allowedUtiTypes: ['public.json']);

    try {
      final path = await FlutterFileDialog.pickFile(params: params);
      if (path == null) {
        Get.snackbar('Import Failed', 'Operation canceled');
      } else {
        final _tmpFile = File(path);
        await _loadFile(_tmpFile);
      }
    } catch (e) {
      Get.snackbar('Import Failed', 'Something went wrong.');
      rethrow;
    }
  }

  void _import() async {
    try {
      unawaited(analytics.logEvent(name: Events.ImportStart, parameters: {
        'characters_count': _charactersToImport.length,
        'classes_count': _classesToImport.length,
      }));
      final user = userController.current;
      final finalChars = Set<Character>.from(characterController.all.values);
      final finalClasses =
          Set<CustomClass>.from(customClassesController.classes.values);
      for (final char in _charactersToImport) {
        final found = finalChars.firstWhere(
            (_char) => _char.displayName == char.displayName,
            orElse: () => null);
        Character added;
        if (found == null) {
          added = await user.createCharacter(char);
        } else {
          added = char.copyWith(order: found.order);
          finalChars.remove(found);
          await found.delete();
        }
        finalChars.add(added);
      }
      for (final cls in _classesToImport) {
        final found = finalClasses.firstWhere((_char) => _char.key == cls.key,
            orElse: () => null);
        CustomClass added;
        if (found == null) {
          added = await user.createCustomClass(cls);
        } else {
          added = cls.copyWith();
          finalClasses.remove(found);
          await found.delete();
        }
        finalClasses.add(added);
      }

      unawaited(analytics.logEvent(name: Events.ImportSuccess, parameters: {
        'characters_count': _charactersToImport.length,
        'classes_count': _classesToImport.length,
      }));

      characterController.setAll(finalChars);
      customClassesController.setAll(finalClasses);

      setState(() {
        _loadedCharacters = {};
        _charactersToImport = {};
        _loadedClasses = {};
        _classesToImport = {};
      });
      Get.snackbar(
        'Import Successful',
        'Your characters were imported without problems',
      );
    } catch (e) {
      unawaited(analytics.logEvent(name: Events.ImportFail, parameters: {
        'reason': e.toString(),
      }));
      Get.snackbar('Import Failed', 'Something went wrong.');
      rethrow;
    }
  }

  void _confirmImport() async {
    final res = await Get.dialog(ConfirmationDialog(
      title: Text('Please Confirm'),
      text: Text(
        'Existing characters and classes that match the imported ones will be overwritten.\n'
        'Characters of classes that are imported will also reflect the new changes.\n'
        "Are you sure that's okay?",
      ),
      okButtonText: Text('Overwrite & Import'),
    ));

    if (res == true) {
      _import();
    }
  }

  void _loadFile(File file) async {
    final str = await file.readAsString();
    final _format = ImportFormat.JSON;
    final data = await _dataParsers[_format]?.call(str);

    setState(() {
      _loadedCharacters = Set.from(data.characters);
      _loadedClasses = Set.from(data.customClasses);
    });
  }

  final Map<ImportFormat, Future<ImportData> Function(String)> _dataParsers = {
    ImportFormat.JSON: (str) async {
      final raw = jsonDecode(str);
      final json = raw is List ? {'characters': raw} : raw;
      final chars = <Character>{
            for (final char in json['characters'] as List<Map<String, dynamic>>)
              await Character.fromJson(
                CharacterMigrations().getData(char),
              ),
          } ??
          [];
      final customClasses = Set<CustomClass>.from(
            json['classes']?.map(
              (v) => CustomClass.fromPlayerClass(
                PlayerClass.fromJSON(v),
                retainKey: true,
              ),
            ),
          ) ??
          [];

      return ImportData(characters: chars, customClasses: customClasses);
    }
  };
}

class _Padded extends StatelessWidget {
  final Widget child;
  final double vertical;
  final double horizontal;

  const _Padded({
    Key key,
    @required this.child,
    this.vertical,
    this.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: child,
      padding: _padding,
    );
  }

  EdgeInsets get _padding {
    var _p = EdgeInsets.symmetric(horizontal: 24, vertical: 8);
    if (vertical != null) {
      _p = _p.copyWith(top: vertical, bottom: vertical);
    }
    if (horizontal != null) {
      _p = _p.copyWith(left: horizontal, right: horizontal);
    }
    return _p;
  }
}

class ImportData {
  final Set<Character> characters;
  final Set<CustomClass> customClasses;

  ImportData({
    @required this.characters,
    @required this.customClasses,
  });
}
