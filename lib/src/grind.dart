import 'dart:async';
import 'package:angular_utility/src/import_optimze_task.dart';


Future angular_utility() async {
  await new ImportOptimizeTask().runTask(config.importOptimize);
}

Config config = new Config();

class Config {
  ImportOptimizeConfig importOptimize = new ImportOptimizeConfig();
}
