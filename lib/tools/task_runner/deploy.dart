import 'dart:io';

import 'args.dart';
import 'task.dart';
import 'task_utils.dart';
import 'tasks/android_tasks.dart';
import 'tasks/ios_tasks.dart';
import 'tasks/test_task.dart';
import 'tasks/web_tasks.dart';

void main(List<String> args) {
  var logTask = LogTask((o) {
    if (!o.hasActionables) {
      if (o.help) {
        print(o.parser.usage);
        exit(0);
      }
      throw Exception('No actions to perform');
    }
    final lst = o.mapLabels.keys.where((k) => o.mapLabels[k] == true).toList();
    final msg = [
      [lst.getRange(0, lst.length - 1).join(', '), lst.last]
              .where((i) => i != null && i.isNotEmpty)
              .join(' & ') +
          (lst.length == 1 ? ' Only' : ''),
      if (o.build == true) 'Platform: ${enumName(o.platform)}',
      'Version: ${o.version}',
    ];
    return msg.join('\n');
  });
  TaskGroup(
    options: ArgOptions.fromArgs(args),
    tasks: [
      logTask,
      testTask,
      android,
      iOS,
      web,
    ],
  ).run();
}
