import 'package:dungeon_paper/db/models/move_template.dart';
import 'package:dungeon_paper/src/dialogs/standard_dialog_controls.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedantic/pedantic.dart';

class MoveTemplateList extends StatelessWidget {
  final void Function(String message) onSelectTemplate;

  const MoveTemplateList({Key key, @required this.onSelectTemplate})
      : super(key: key);

  static const _defaultTemplates = <MoveTemplate>[
    MoveTemplate(
      shortLabel: 'Simple',
      longLabel: 'Simple move',
      help: 'Basic template for simple move.',
      text: _singleBoth,
    ),
    MoveTemplate(
      shortLabel: 'Multi. choice',
      longLabel: 'Multiple choice success & trouble',
      help:
          'Template with multiple options for success,\nand multiple options for trouble.',
      text: _multiBoth,
    ),
    MoveTemplate(
      shortLabel: 'Multi. success',
      longLabel: 'Multiple choice success',
      help:
          'Template with multiple options for success,\nbut only one outcome for trouble.',
      text: _multiSuccess,
    ),
    MoveTemplate(
      shortLabel: 'Multi. trouble',
      longLabel: 'Multiple choice trouble',
      help:
          'Template with multiple options for trouble,\nbut only one outcome for success.',
      text: _multiFail,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExpansionTile(
          title: Text('Move templates'),
          tilePadding: EdgeInsets.symmetric(vertical: 0),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tap template button to insert template text into "Description" box. '
              '(Inserts at current cursor position)\n'
              'Long-tap to preview template.',
            ),
            SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              // runSpacing: -6,
              children: [
                for (final template in _defaultTemplates) ...[
                  // Tooltip(
                  //   message: template.help,
                  // child:
                  InkWell(
                    child: ActionChip(
                      label: Text(template.shortLabel),
                      onPressed: _insert(template),
                      visualDensity: VisualDensity.compact,
                    ),
                    onLongPress: _preview(template),
                  ),
                  // ),
                  SizedBox(width: 8),
                ]
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  static const _blank = '_____'; // or '…'?
  static const _bullet = '-';

  static const _singleBoth =
      'When you $_blank, roll+STAT. On a 10+, you succeed $_blank. '
      'On a 7-9, you fail $_blank.';

  static const _multiSuccess =
      'When you $_blank, roll+STAT. On a 10+, you succeed and choose:\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n'
      'On a 7-9, you fail $_blank.';

  static const _multiFail =
      'When you $_blank, roll+STAT. On a 10+, you succeed $_blank. On a 7-9, choose one:\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n';

  static const _multiBoth =
      'When you $_blank, roll+STAT. On a 10+, you succeed and choose:\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n'
      'On a 7-9, choose one:\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n'
      '  $_bullet $_blank\n';

  void Function() _insert(MoveTemplate template) => () {
        unawaited(
            analytics.logEvent(name: Events.InsertMoveTemplate, parameters: {
          'template': template.shortLabel,
        }));
        onSelectTemplate?.call(template.text);
      };

  void Function() _preview(MoveTemplate template) => () {
        unawaited(
            analytics.logEvent(name: Events.PreviewMoveTemplate, parameters: {
          'template': template.shortLabel,
        }));
        Get.dialog(
          _TemplatePreviewDialog(
            template: template,
            onInsert: _insert(template),
          ),
        );
      };
}

class _TemplatePreviewDialog extends StatelessWidget {
  const _TemplatePreviewDialog({
    Key key,
    @required this.template,
    @required this.onInsert,
  }) : super(key: key);

  final MoveTemplate template;
  final VoidCallback onInsert;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(template.longLabel + ' preview'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(template.help, style: Get.theme.textTheme.caption),
          SizedBox(height: 24),
          Text(template.text),
        ],
      ),
      actions: StandardDialogControls.actions(
        context: context,
        onConfirm: () {
          onInsert?.call();
          Get.back();
        },
        onCancel: () => Get.back(),
        confirmText: Text('Insert Template'),
        cancelText: Text('Close'),
      ),
    );
  }
}
