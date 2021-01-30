import 'dart:convert';
import 'dart:io';

import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/custom_class.dart';
import 'package:dungeon_paper/src/lists/character_select_list.dart';
import 'package:dungeon_paper/src/lists/custom_class_select_list.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_world_data/player_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';

class ExportView extends StatefulWidget {
  @override
  _ExportViewState createState() => _ExportViewState();
}

enum ExportFormat {
  JSON,
  Excel,
  // HTML,
  // PDF,
}

class _ExportViewState extends State<ExportView> {
  Set<Character> _charactersToExport;
  Set<PlayerClass> _classesToExport;
  Set<CustomClass> _allCustomClasses;
  ExportFormat _format;

  @override
  void initState() {
    super.initState();
    _format = ExportFormat.JSON;
    _charactersToExport = {};
    _allCustomClasses = Set.from(customClassesController.classes.values);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Padded(
          child: Text(
            'Select data to export',
            style: Get.theme.textTheme.headline6,
          ),
        ),
        if (_dataParsers.values.length > 1)
          _Padded(
            child: Row(
              children: [
                Text('Select export format:'),
                SizedBox(width: 16),
                DropdownButton(
                  value: _format,
                  onChanged: _setFormat,
                  items: [
                    for (final format in ExportFormat.values)
                      if (_dataParsers[format] != null)
                        DropdownMenuItem(
                          child: Text(enumName(format)),
                          value: format,
                        ),
                  ],
                ),
              ],
            ),
          ),
        ExpansionTile(
          title: Text('Characters'),
          children: [
            CharacterSelectList(
              selected: _charactersToExport,
              onChange: (chars) => setState(() => _charactersToExport = chars),
            ),
          ],
        ),
        if (_allCustomClasses?.isNotEmpty == true)
          ExpansionTile(
            title: Text('Custom Classes'),
            children: [
              CustomClassSelectList(
                selected: _classesToExport,
                onChange: (chars) => setState(() => _classesToExport = chars),
              ),
            ],
          ),
        SizedBox(height: 16),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: RaisedButton.icon(
              padding: const EdgeInsets.all(8),
              icon: Icon(Icons.file_upload),
              label: Text(
                'Export',
                textScaleFactor: 1.5,
              ),
              onPressed: _charactersToExport?.isNotEmpty == true ||
                      _classesToExport?.isNotEmpty == true
                  ? _export
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _export() async {
    unawaited(analytics.logEvent(name: Events.ExportStart, parameters: {
      'characters_count': _charactersToExport.length,
      'classes_count': _classesToExport.length,
    }));
    final _strData = await _dumpDataString();
    final tmp = await getTemporaryDirectory();
    final ext = formatExts[_format];
    final dt = DateTime.now().toIso8601String();
    final fileName = 'dungeon-paper-$dt.$ext';

    final _tmpFile = File(join(tmp.path, fileName));
    await _tmpFile.writeAsBytes(_strData);

    final params = SaveFileDialogParams(sourceFilePath: _tmpFile.path);
    try {
      final path = await FlutterFileDialog.saveFile(params: params);
      if (path == null) {
        unawaited(analytics.logEvent(name: Events.ExportFail, parameters: {
          'reason': 'user_canceled',
        }));
        Get.snackbar('Export Failed', 'Operation canceled');
      } else {
        unawaited(analytics.logEvent(name: Events.ExportSuccess, parameters: {
          'characters_count': _charactersToExport.length,
          'classes_count': _classesToExport.length,
        }));
        Get.snackbar(
          'Export Successful',
          'Your data was exported without problems.',
        );
      }
    } catch (e) {
      unawaited(analytics.logEvent(name: Events.ExportFail, parameters: {
        'reason': e.toString(),
      }));
      Get.snackbar('Export Failed',
          'Something went wrong.\nTry again or contact support if this persists.');
      rethrow;
    }
  }

  Future<List<int>> _dumpDataString() async {
    if (_dataParsers[_format] == null) {
      return null;
    }
    final chars = Set<Character>.from(
        _charactersToExport.toList()..sort((a, b) => a.order - b.order));

    final classes = {..._classesToExport};

    return await _dataParsers[_format]
        .call(ExportData(characters: chars, customClasses: classes));
  }

  static Map<ExportFormat, String> formatExts = {
    ExportFormat.JSON: 'json',
    ExportFormat.Excel: 'xlsx',
  };

  static final Map<ExportFormat, Future<List<int>> Function(ExportData)>
      _dataParsers = {
    ExportFormat.JSON: (data) {
      final charsData = data.characters.map((char) => char.toJson()).toList();
      final classesData =
          data.customClasses.map((char) => char.toJSON()).toList();
      final _strData =
          jsonEncode({'characters': charsData, 'classes': classesData});
      return Future.value(utf8.encode(_strData));
    },
    // ExportFormat.Excel: (data) async {
    //   final xl = Excel.createExcel();
    //   for (final char in data.characters) {
    //     xl['Character: ' + char.displayName] =
    //         await generateCharacterExcelSheet(char);
    //   }
    //   return xl.encode();
    // },
  };

  void _setFormat(ExportFormat format) {
    if (format != null) {
      setState(() {
        _format = format;
      });
    }
  }
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

class ExportData {
  final Set<Character> characters;
  final Set<PlayerClass> customClasses;

  ExportData({
    @required this.characters,
    @required this.customClasses,
  });
}
