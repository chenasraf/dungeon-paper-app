import '../args.dart';
import '../task.dart';

// final installWeb = TaskGroup(
//   condition: (o) => o.install == true,
//   tasks: [
//     LogTask((o) => 'Installing ${o.version} ${o.devicePrefix('on ')}'),
//     ProcessTask(
//       (_) => 'adb',
//       args: (o) => [...o.deviceArgs, 'install', '-r', o.apkPath],
//       onError: (o, e, stack) async {
//         TaskGroup(
//           tasks: [
//             LogTask.staticArgs(
//                 'Failed to install. Uninstalling old version...'),
//             ProcessTask.staticArgs(
//               'adb',
//               args: [...o.deviceArgs, 'uninstall', 'app.dungeonpaper'],
//             ),
//             LogTask.staticArgs('Installing new version...'),
//             ProcessTask.staticArgs(
//               'adb',
//               args: [...o.deviceArgs, 'install', '-r', o.apkPath],
//             ),
//           ],
//         ).run(o);
//       },
//     ),
//   ],
// );

// final pushWeb = TaskGroup(
//   condition: (o) => o.push == true,
//   tasks: [
//     LogTask((o) => 'Pushing to ${o.outputPath}'),
//     ProcessTask(
//       (_) => 'adb',
//       args: (o) => [...o.deviceArgs, 'push', o.apkPath, o.outputPath],
//     ),
//   ],
// );

final buildWeb = TaskGroup(
  condition: (o) => o.build == true,
  tasks: [
    LogTask((o) => 'Building web'),
    ProcessTask.staticArgs(
      'flutter',
      args: [
        'build',
        'web',
        // '--release-name',
        // '--release-number',
      ],
    ),
  ],
);

final web = DeviceTaskGroup(
  device: Device.web,
  tasks: [
    buildWeb,
    // pushWeb,
    // installWeb,
  ],
);
