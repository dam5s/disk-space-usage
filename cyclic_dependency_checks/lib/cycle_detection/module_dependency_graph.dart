import 'dart:isolate';

import 'imported_dependency.dart';
import 'list_extensions.dart';
import 'module_dependency.dart';

class ModuleDependencyGraph {
  final String appPackage;
  final List<ImportedDependency> _dependencies = [];
  final Set<ModuleDependency> _moduleDependencies = {};

  ModuleDependencyGraph({required this.appPackage});

  void addAll(List<ImportedDependency> dependencies) {
    _dependencies.addAll(dependencies);
    _moduleDependencies.addAll(dependencies.map(
      (d) => ModuleDependency(from: d.sourceModule, to: d.importedModule),
    ));
  }

  Future<List<List<ModuleDependency>>> detectCycles({int? maxDepth}) async {
    final moduleCount = _countModules();
    final actualMaxDepth = maxDepth ?? moduleCount;

    final resultsFutures = _moduleDependencies.map((value) => Isolate.run(
          () => _detectDependencyCycles([value], maxDepth: actualMaxDepth),
        ));

    return (await Future.wait(resultsFutures)).flatten();
  }

  int _countModules() {
    final allModules = <Module>{};
    for (var value in _moduleDependencies) {
      allModules.addAll([value.from, value.to]);
    }
    return allModules.length;
  }

  Future<List<List<ModuleDependency>>> _detectDependencyCycles(
    List<ModuleDependency> currentPath, {
    required int maxDepth,
  }) async {
    if (currentPath.hasCycle()) {
      return [currentPath];
    }

    if (currentPath.length - 1 > maxDepth) {
      return [];
    }

    final last = currentPath.last;
    final nextOptions = _moduleDependencies.where((dep) => dep.from == last.to);

    final resultsFutures = nextOptions.map((next) => _detectDependencyCycles(
          List.from(currentPath)..add(next),
          maxDepth: maxDepth,
        ));

    return (await Future.wait(resultsFutures)).flatten();
  }

  @override
  String toString() => _moduleDependencies.map((d) => d.toString()).join('\n');
}

extension CycleDetection on List<ModuleDependency> {
  List<Module> path() => map((dep) => dep.from).toList()..add(last.to);

  bool hasCycle() {
    final allModules = path();
    return allModules.length > allModules.toSet().length;
  }
}
