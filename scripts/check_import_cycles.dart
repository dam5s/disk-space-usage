import 'dart:io';

import 'imported_dependency.dart';
import 'module_dependency_graph.dart';

const appPackage = 'disk_space_usage';

void main() async {
  final graph = ModuleDependencyGraph(appPackage: appPackage);

  await for (final entity in Directory('lib').list(recursive: true)) {
    final path = entity.path;

    if (!path.endsWith('.dart')) {
      continue;
    }

    final content = await File(path).readAsString();
    final source = SourceFile(path);

    final importResults = content
        .split('\n')
        .where((line) => line.startsWith('import '))
        .map((line) => ImportedDependency.tryCreate(appPackage, source, line));

    for (var res in importResults) {
      if (res is DisallowedNestedImport) {
        throw Exception('Found a disallowed dependency, from $path to ${res.import}');
      }
    }

    final validImports = importResults.expand<ImportedDependency>((res) {
      if (res is ValidImport) {
        return [res.dependency];
      } else {
        return [];
      }
    }).toList();

    graph.addAll(validImports);
  }

  print(graph);
}
