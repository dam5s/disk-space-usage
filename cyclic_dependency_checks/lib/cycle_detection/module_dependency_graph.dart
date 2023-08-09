import 'imported_dependency.dart';
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

  List<List<ModuleDependency>> detectCycles() {
    final allCycles = <List<ModuleDependency>>[];
    final moduleCount = _countModules();

    for (var value in _moduleDependencies) {
      allCycles.addAll(_detectDependencyCycles(
        [value],
        maxDepth: moduleCount,
      ));
    }

    return allCycles;
  }

  int _countModules() {
    final allModules = <Module>{};
    for (var value in _moduleDependencies) {
      allModules.addAll([value.from, value.to]);
    }
    return allModules.length;
  }

  List<List<ModuleDependency>> _detectDependencyCycles(List<ModuleDependency> currentPath,
      {required int maxDepth, int currentDepth = 0}) {
    if (currentPath.hasCycle()) {
      return [currentPath];
    }

    if (currentDepth > maxDepth) {
      return [];
    }

    final last = currentPath.last;
    final nextOptions = _moduleDependencies.where((dep) => dep.from == last.to);

    return nextOptions
        .expand((next) => _detectDependencyCycles(
              List.from(currentPath)..add(next),
              maxDepth: maxDepth,
              currentDepth: currentDepth + 1,
            ))
        .toList();
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
