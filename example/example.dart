import 'dart:async';
import 'package:angular_utility/angular_utility.dart';

Future<Null> main(List<String> args) async {
  config.importOptimize.packagesToCheck.addAll(['glob', 'source_span', 'grinder']);
  angular_utility();
}