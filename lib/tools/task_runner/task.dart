import 'dart:async';
import 'dart:io';
import 'args.dart';

class Task<T> {
  final bool Function(T) condition;
  final T options;
  final FutureOr<void> Function(T) _run;

  Task({
    this.condition,
    FutureOr<void> Function(T) run,
    T options,
  })  : _run = run,
        options = options;

  factory Task.staticArgs({
    bool condition,
    FutureOr<void> Function() run,
    T options,
  }) =>
      Task(
        condition: condition != null ? (_) => condition : null,
        run: (_) => run(),
        options: options,
      );

  FutureOr<void> dispose() {}

  FutureOr<void> run([T options]) async {
    await _run(options ?? this.options);
    dispose();
  }
}

class TaskGroup<T> extends Task<dynamic> {
  final List<Task> tasks;

  TaskGroup({
    bool Function(dynamic) condition,
    this.tasks,
    dynamic options,
  }) : super(
          condition: condition,
          run: _runTasks(tasks, options, condition),
          options: options,
        );

  TaskGroup.staticArgs({
    bool condition,
    this.tasks,
    dynamic options,
  }) : super(
          condition: condition != null ? (_) => condition : null,
          run: _runTasks(
            tasks,
            options,
            condition != null ? (_) => condition : null,
          ),
          options: options,
        );

  @override
  FutureOr<void> run([dynamic options]) =>
      _runTasks(tasks, options ?? this.options, condition).call(null);

  static Future<void> Function(T) _runTasks<T>(
    List<Task> tasks,
    T options,
    bool Function(T) condition,
  ) {
    return (_) async {
      for (final task in tasks) {
        if (condition?.call(options) != false &&
            task.condition?.call(options) != false) {
          await task.run(options);
        }
      }
    };
  }

  @override
  void dispose() {
    for (final task in tasks) {
      if (task.condition?.call(options) != false) {
        task.dispose();
      }
    }
    super.dispose();
  }
}

class DeviceTaskGroup extends TaskGroup<ArgOptions> {
  DeviceTaskGroup({
    Device device,
    List<Task> tasks,
    bool Function(ArgOptions) condition,
  }) : super(
          condition: condition != null
              ? (o) =>
                  condition.call(o) != false && _isDeviceIncluded(o, device)
              : (o) => _isDeviceIncluded(o, device),
          tasks: tasks,
        );

  DeviceTaskGroup.staticArgs({
    Device device,
    List<Task> tasks,
    bool condition,
  }) : super(
          condition: (o) => condition != false && _isDeviceIncluded(o, device),
          tasks: tasks,
        );

  static bool _isDeviceIncluded(ArgOptions o, Device device) =>
      o.platform == Device.all || o.platform == device;
}

class ProcessTask extends Task<ArgOptions> {
  ProcessTask(
    FutureOr<String> Function(ArgOptions) process, {
    FutureOr<List<String>> Function(ArgOptions) args,
    bool Function(ArgOptions) condition,
    FutureOr<void> Function(ArgOptions) beforeAll,
    FutureOr<void> Function(ArgOptions) afterAll,
    FutureOr<void> Function(ArgOptions, Exception, StackTrace) onError,
  }) : super(
          condition: condition,
          run: _runProcess(process, args, onError),
        );

  factory ProcessTask.staticArgs(
    String process, {
    List<String> args,
    bool condition,
    FutureOr<void> Function(ArgOptions) beforeAll,
    FutureOr<void> Function(ArgOptions) afterAll,
    FutureOr<void> Function(ArgOptions, Error, StackTrace) onError,
  }) =>
      ProcessTask(
        (_) => process,
        args: args != null ? (_) => args : null,
        condition: condition != null ? (_) => condition : null,
        beforeAll: beforeAll,
        afterAll: afterAll,
      );

  static FutureOr<void> Function(ArgOptions) _runProcess(
    FutureOr<String> Function(ArgOptions) process,
    FutureOr<List<String>> Function(ArgOptions) args,
    FutureOr<void> Function(ArgOptions, Exception, StackTrace) onError,
  ) =>
      (o) async {
        final _process = await process(o);
        final _args = await (args?.call(o) ?? <String>[]);
        final _argsStr =
            _args.map((a) => a.contains(' ') ? '"$a"' : a).join(' ');
        print('\n\nRunning process: $_process ${_argsStr}\n\n');
        try {
          final result = await Process.run(_process, _args);
          stdout.write(result.stdout);
          stdout.write(result.stderr);
          final exitCode = await result.exitCode;
          if (exitCode != 0) {
            final stack = StackTrace.current;
            final e = ProcessException(_process, _args,
                'Process exited with error code: $exitCode', exitCode);
            _handleError(o, e, stack, onError);
          }
        } catch (e, stack) {
          _handleError(o, e, stack, onError);
        }
      };

  @override
  void dispose() async {
    await stdout.flush();
    await stderr.flush();
    super.dispose();
  }

  static void _handleError(ArgOptions o, Exception e, StackTrace stack,
      FutureOr<void> Function(ArgOptions, Exception, StackTrace) onError) {
    if (onError != null) {
      onError(o, e, stack);
    } else {
      throw e;
    }
  }
}

class LogTask extends Task<ArgOptions> {
  LogTask(
    FutureOr<String> Function(ArgOptions) message, {
    bool Function(ArgOptions) condition,
  }) : super(
          condition: condition,
          run: _log(message),
        );

  LogTask.staticArgs(
    String message, {
    bool Function(ArgOptions) condition,
  }) : super(
          condition: condition,
          run: _log((o) => message),
        );

  FutureOr<void> log(String message) => _log((o) => message);

  static Future<void> Function(ArgOptions) _log(
    FutureOr<String> Function(ArgOptions) message,
  ) =>
      (o) async => print(await message(o));
}
