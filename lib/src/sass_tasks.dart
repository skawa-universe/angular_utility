import 'dart:async';
import 'package:angular_utility/src/grind_task.dart';
import 'package:build_runner/build_runner.dart';
import 'package:sass_builder/sass_builder.dart';

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
    return build([new BuildAction(new SassBuilder(), 'skawa_components')],
        deleteFilesByDefault: true, writeToCache: true);
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
    return watch([new BuildAction(new SassBuilder(), 'skawa_components')],
        deleteFilesByDefault: true, writeToCache: true);
  }
}
