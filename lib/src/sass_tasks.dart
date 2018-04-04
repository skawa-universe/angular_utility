import 'dart:async';
import 'package:angular_utility/src/grind_task.dart';
import 'package:build_runner/build_runner.dart';
import 'package:sass_builder/sass_builder.dart';

class SassBuildConfig implements TaskConfig {
  @override
  bool verbose = true;

  @override
  bool shouldRun = true;

  String package;
}

class SassBuildTask extends GrindTask {
  @override
  Future task(SassBuildConfig taskConfig) async {
    if (taskConfig.package.isEmpty) throw new ArgumentError('package have to configured!');
    return build([new BuildAction(new SassBuilder(), taskConfig.package)], deleteFilesByDefault: true);
  }
}

class SassWatchConfig implements TaskConfig {
  @override
  bool verbose = true;

  @override
  bool shouldRun = true;

  String package;
}

class SassWatchTask extends GrindTask {
  @override
  Future task(SassWatchConfig taskConfig) async {
    if (taskConfig.package.isEmpty) throw new ArgumentError('package have to configured!');
    return watch([new BuildAction(new SassBuilder(), taskConfig.package)], deleteFilesByDefault: true);
  }
}
