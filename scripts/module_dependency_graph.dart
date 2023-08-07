import 'imported_dependency.dart';
import 'module_dependency.dart';

class ModuleDependencyGraph {
  final String appPackage;
  final Set<ModuleDependency> _dependencies = {};

  ModuleDependencyGraph({required this.appPackage});

  void addDependency(ImportedDependency dependency) {
    final importModule = _importModule(dependency.import);

    if (importModule == null) {
      return;
    }

    final sourceModule = _sourceModule(dependency.source);
    if (importModule == sourceModule) {
      return;
    }

    _dependencies.add(ModuleDependency(
      from: sourceModule,
      to: importModule,
    ));
  }

  void addAll(List<ImportedDependency> dependencies) {
    for (var d in dependencies) {
      addDependency(d);
    }
  }

  Module _sourceModule(SourceFile source) {
    final components = source.path.split('/')
      ..removeLast()
      ..removeAt(0)
      ..insert(0, appPackage);
    final path = components.join('/');

    return Module(path);
  }

  Module? _importModule(String import) {
    if (!import.startsWith('package:$appPackage/')) {
      return null;
    }

    final components = import.replaceFirst('package:', '').split('/')..removeLast();

    return Module(components.join('/'));
  }

  List<List<ModuleDependency>> detectCycles() {
    final allCycles = <List<ModuleDependency>>[];

    for (var value in _dependencies) {
      allCycles.addAll(_detectDependencyCycles([value]));
    }

    return allCycles;
  }

  List<List<ModuleDependency>> _detectDependencyCycles(List<ModuleDependency> path) {
    if (path.hasCycle()) {
      return [path];
    }

    final last = path.last;
    final nextOptions = _dependencies.where((dep) => dep.from == last.to);

    return nextOptions
        .expand((next) => _detectDependencyCycles(List.from(path)..add(next)))
        .toList();
  }

  @override
  String toString() => _dependencies.map((d) => d.toString()).join('\n');
}

extension CycleDetection on List<ModuleDependency> {
  List<Module> path() => map((dep) => dep.from).toList()..add(last.to);

  bool hasCycle() {
    final allModules = path();
    return allModules.length > allModules.toSet().length;
  }
}