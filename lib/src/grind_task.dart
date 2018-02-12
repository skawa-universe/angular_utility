import 'dart:async';

abstract class GrindTask {
  Future<dynamic> runTask(TaskConfig taskConfig);
}

abstract class TaskConfig {
  bool verbose = true;
}
