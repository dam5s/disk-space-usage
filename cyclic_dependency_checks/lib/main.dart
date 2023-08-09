import 'dart:io';

import 'cycle_detection/cycle_detector.dart';
import 'cycle_detection/module_dependency.dart';
import 'cycle_detection/module_dependency_graph.dart';

void main(List<String> args) async {
  switch (args) {
    case [final path]:
      await _run(path);
    default:
      throw Exception(
          'Expected exactly only one argument, the path to dart package folder as argument');
  }
}

Future _run(String path) async {
  final cycles = await CycleDetector().detect(path);

  if (cycles.isNotEmpty) {
    stderr.writeln('Detected cycles');
    for (var cycle in cycles) {
      cycle.printError();
    }
    exit(1);
  }

  stdout.writeln('No import cycles were detected');
}

extension ErrorPrinting on List<ModuleDependency> {
  void printError() {
    stderr.writeln(path().join(' -> '));
  }
}
