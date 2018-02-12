import 'dart:async';
import 'package:angular_utility/src/grind_task.dart';
import 'package:grinder/grinder_sdk.dart';

class SassBuildConfig implements TaskConfig {
  @override
  bool verbose = true;

  @override
  bool shouldRun = true;
}

class SassBuildTask extends GrindTask {
  /// This task should check that, the given packages has imported files/directives/providers
  /// which will inflates file size. This method helps locating these imports.
  ///
  @override
  Future task(SassBuildConfig taskConfig) async {
    return Dart.run(r'tool/sass_build.dart', quiet: !taskConfig.verbose);
  }
}

class SassWatchConfig implements TaskConfig {
  @override
  bool verbose = true;

  @override
  bool shouldRun = true;
}

class SassWatchTask extends GrindTask {
  /// This task should check that, the given packages has imported files/directives/providers
  /// which will inflates file size. This method helps locating these imports.
  ///
  @override
  Future task(SassWatchConfig taskConfig) async {
    return Dart.runAsync(r'tool/sass_watch.dart', quiet: !taskConfig.verbose);
  }
}