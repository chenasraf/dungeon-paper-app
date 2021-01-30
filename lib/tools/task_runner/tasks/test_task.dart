import '../task.dart';

final testTask = TaskGroup(
  condition: (o) => o.test == true,
  tasks: [
    LogTask((o) => 'Running Tests'),
    ProcessTask.staticArgs(
      'flutter',
      args: ['test'],
      onError: (_, __, ___) => throw Exception('Test failed'),
    ),
  ],
);
