class Module {
  final String path;

  Module(this.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Module && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() => 'module:$path';
}

class ModuleDependency {
  final Module from;
  final Module to;

  ModuleDependency({required this.from, required this.to});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleDependency &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode => from.hashCode ^ to.hashCode;

  @override
  String toString() => '$from -> $to';
}
