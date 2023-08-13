import 'package:cyclic_dependency_checks/cycle_detection/cycle_detector.dart';
import 'package:test/test.dart';

void main() {
  test('in codebase with no cycles', () async {
    final result = await CycleDetector()
        .detect('test_resources/example_codebase_no_cycles');
    expect(result, hasLength(0));
  });

  test('in codebase with cycles', () async {
    final result = await CycleDetector()
        .detect('test_resources/example_codebase_with_cycles');
    expect(result.length, greaterThan(0));
  });

  test('big codebase', () async {
    final result = await CycleDetector()
        .detect('test_resources/example_big_codebase', maxDepth: 8);
    expect(result.length, greaterThanOrEqualTo(0));
  });
}
