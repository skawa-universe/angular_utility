import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

Future processStart(ProcessInformation processInformation, bool dry) async {
  try {
    List<String> arguments = new List.from(processInformation.arguments ?? []);
    if (dry && processInformation.dryArg != null) arguments.add(processInformation.dryArg);
    log.info('${processInformation.processName} prepared.');
    Process _serveProcess = await Process.start(processInformation.executable, arguments);
    log.fine('${processInformation.processName} started.');
    _serveProcess.stdout.asBroadcastStream().transform(UTF8.decoder).listen(trimmedPrint);
    _serveProcess.stderr.asBroadcastStream().transform(UTF8.decoder).listen(trimmedError);
    var a = await _serveProcess.exitCode;
    log.fine('${processInformation.processName} finished.');
    return a == 0;
  } on Exception catch (e) {
    log.severe('Could not ${processInformation.processName}', e);
    return false;
  }
}

class ServeProcess {
  Process _serveProcess;

  Future processStart(ProcessInformation processInformation, bool dry) async {
    try {
      Completer<bool> resultCompleter = new Completer<bool>();
      List<String> arguments = new List.from(processInformation.arguments ?? []);
      if (dry && processInformation.dryArg != null) arguments.add(processInformation.dryArg);
      log.info('${processInformation.processName} prepared.');
      _serveProcess = await Process.start(processInformation.executable, arguments);
      log.fine('${processInformation.processName} started.');
      var stdoutBroadcast = _serveProcess.stdout.asBroadcastStream();
      stdoutBroadcast.transform(UTF8.decoder).transform(new LineSplitter()).listen((String line) {
        if (line.contains('Build completed successfully')) {
          resultCompleter.complete(true);
        }
      }, onDone: () {
        if (!resultCompleter.isCompleted) {
          resultCompleter.completeError(false);
        }
      });
      stdoutBroadcast.transform(UTF8.decoder).listen(trimmedPrint);
      _serveProcess.stderr.asBroadcastStream().transform(UTF8.decoder).listen(trimmedError);
      return resultCompleter.future;
    } on Exception catch (e) {
      log.severe('Could not ${processInformation.processName}', e);
      return false;
    }
  }

  Future close() async => _serveProcess?.kill();
}

class ProcessInformation {
  /// string of the executable of the Process.start
  final String executable;

  /// the list of arguments of the Process.start
  final List<String> arguments;

  /// the dry argument options
  final String dryArg;

  /// the name which under we want to log this process
  final String processName;

  const ProcessInformation(this.executable, this.arguments, this.processName, {this.dryArg});
}

final Logger log = new Logger('ProcessRunner');

trimmedPrint(String event) {
  var rowList = event.split('\n');
  rowList.forEach((String splittedEvent) {
    if (splittedEvent != null && splittedEvent.trim().isNotEmpty) log.finest(splittedEvent.trim());
  });
}

trimmedError(String event) {
  var rowList = event.split('\n');
  rowList.forEach((String splitedEvent) {
    if (splitedEvent != null && splitedEvent.trim().isNotEmpty) log.warning(splitedEvent.trim());
  });
}
