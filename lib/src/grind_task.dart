import 'dart:async';

abstract class GrindTask {
  Future<dynamic> task(TaskConfig taskConfig);

  Future<dynamic> runTask(TaskConfig taskConfig) {
    if (taskConfig.shouldRun) return task(taskConfig);
    return null;
  }
}

abstract class TaskConfig {
  bool verbose = true;

  bool shouldRun = true;
}
