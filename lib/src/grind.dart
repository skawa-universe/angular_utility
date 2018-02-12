import 'dart:async';
import 'package:angular_utility/src/import_optimze_task.dart';
import 'package:angular_utility/src/sass_tasks.dart';

Future checkImport() async {
  await new ImportOptimizeTask().task(config.importOptimize);
}

Future sassBuild() async {
  await new SassBuildTask().task(config.sassBuildConfig);
}

Future sassWatch() async {
  await new SassWatchTask().task(config.sassWatchConfig);
}

Config config = new Config();

class Config {
  ImportOptimizeConfig importOptimize = new ImportOptimizeConfig();
  SassBuildConfig sassBuildConfig = new SassBuildConfig();
  SassWatchConfig sassWatchConfig = new SassWatchConfig()..shouldRun = false;
}
