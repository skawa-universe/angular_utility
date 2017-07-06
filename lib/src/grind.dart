import 'dart:async';
import 'dart:io';
import 'package:grinder/grinder.dart';
import 'package:glob/glob.dart';
import 'package:source_span/source_span.dart' as span;
import 'package:source_span/src/colors.dart' as span_color;
import 'package:package_resolver/package_resolver.dart';

Future grindAll(List<String> package, {List<ErrorPattern> errorPatternList: const[]}) async {
  List packageList = [await libDir.path];
  await Future.forEach(package, (String package) async {
    packageList.add(await PackageResolver.current.packagePath(package));
  });
  List<ErrorResult> errorCases = [];
  packageList.forEach((String package) {
    errorCases.addAll(_grind(package, errorPatternList: errorPatternList));
  });
  if (errorCases.isNotEmpty) {
    print(_buildError(errorCases));
    throw new StateError('There are invalid uses of imports');
  }
}

List<ErrorResult> _grind(String package, {List<ErrorPattern> errorPatternList}) {
  final dartFiles = new Glob("${package}/**.dart");
  final errorCases = <ErrorResult>[];
  for (var entity in dartFiles.listSync(root: '.', followLinks: false)) {
    if (entity is! File) {
      continue;
    }
    File dartFile = entity as File;
    final errorPatterns = <ErrorPattern>[
      fullAngularComponentsImport,
      fullSkawaComponentsImport,
      fullMaterialDirective,
      fullMaterialProviders
    ]
      ..addAll(errorPatternList);
    final fileContents = dartFile.readAsStringSync();
    for (var pattern in errorPatterns) {
      var match = pattern.pattern.firstMatch(fileContents);
      if (match == null) continue;
      var sf = new span.SourceFile.fromString(fileContents, url: dartFile.uri.toFilePath());
      span.SourceSpan errorSpan;
      if (match.groupCount > 0) {
        var g = match.group(1);
        var start = fileContents.indexOf(g);
        errorSpan = sf.span(start, start + g.length);
      } else {
        errorSpan = sf.span(match.start, match.end);
      }
      errorCases.add(new ErrorResult(pattern, errorSpan));
    }
  }
  return errorCases;
}

String _buildError(List<ErrorResult> errorCases) {
  StringBuffer error = new StringBuffer('Problems in files:\n');
  for (var err in errorCases) {
    error..writeln(err.errorSpan.message(err.pattern.description, color: span_color.RED));
  }
  return error.toString();
}

class ErrorPattern {
  final RegExp pattern;
  final String description;

  ErrorPattern(this.pattern, this.description);
}

class ErrorResult {
  final ErrorPattern pattern;
  final span.SourceSpan errorSpan;

  ErrorResult(this.pattern, this.errorSpan);
}

final ErrorPattern fullAngularComponentsImport = new ErrorPattern(
    new RegExp(r'''import\s+['"]{1}package:angular_components/angular_components\.dart['"]{1}''', caseSensitive: false),
    'Imports angular_components/angular_components.dart that inflates compiled file size.');
final ErrorPattern fullSkawaComponentsImport = new ErrorPattern(
    new RegExp(r'''import\s+['"]{1}package:skawa_components/skawa_components\.dart['"]{1}''', caseSensitive: false),
    'Imports skawa_components/skawa_components.dart that inflates compiled file size.');
final ErrorPattern fullMaterialDirective = new ErrorPattern(
    new RegExp(r'''directives:\s*const\s+\[.*(materialDirectives).*\]'''),
    'Uses `materialDirectives` that inflates file size. Use only what you need!');
final ErrorPattern fullMaterialProviders = new ErrorPattern(
    new RegExp(r'''providers:\s*const\s+\[.*(materialProviders).*\]'''),
    'Uses `materialDirectives` that inflates file size. Use only what you need!');
