import 'dart:io';

import 'imported_dependency.dart';
import 'module_dependency.dart';
import 'module_dependency_graph.dart';

class CycleDetector {
  Future<List<List<ModuleDependency>>> detect(String packagePath) async {
    final pubspecFile = File('$packagePath/pubspec.yaml');
    final pubspecContent = await pubspecFile.readAsLines();
    final appPackage = pubspecContent.firstOrNull?.replaceFirst('name: ', '');
    final libPath = '$packagePath/lib';

    if (appPackage == null) {
      throw Exception('Could not read appPackage from file ${pubspecFile.absolute.path}');
    }

    final graph = ModuleDependencyGraph(appPackage: appPackage);

    await for (final entity in Directory(libPath).list(recursive: true)) {
      final entityPath = entity.path;

      if (!entityPath.endsWith('.dart')) {
        continue;
      }

      final content = await File(entityPath).readAsString();
      final relativePath = entityPath.replaceFirst(libPath, '');
      final source = SourceFile(relativePath);

      final importResults = content
          .split('\n')
          .where((line) => line.startsWith('import '))
          .map((line) => ImportedDependency.tryCreate(appPackage, source, line));

      for (var res in importResults) {
        if (res is DisallowedNestedImport) {
          throw Exception('Found a disallowed dependency, from $entityPath to ${res.import}');
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

    return graph.detectCycles();
  }
}
