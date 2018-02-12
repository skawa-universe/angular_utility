@TestOn('vm')
import 'package:test/test.dart';
import 'package:angular_utility/angular_utility.dart';

main() {
  test('ImportOptimizeTask should throw', () async {
    expect(() async =>
    await new ImportOptimizeTask().runTask(
        new ImportOptimizeConfig()
          ..pathToCheck.add('test')
          ..verbose = false), throwsStateError);
  });
}