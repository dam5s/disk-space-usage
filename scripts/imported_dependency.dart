class ImportedDependency {
  final SourceFile source;
  final String import;

  ImportedDependency._(this.source, this.import);

  @override
  String toString() => 'src: ${source.path}, import: $import';

  static DependencyCreationResult tryCreate(String appPackage, SourceFile source, String importLine) {
    final import = importLine.split("'")[1];
    final isStandardLibrary = import.startsWith('dart:');
    final isPackageDependency = import.startsWith('package:');
    final isAppPackageDependency = import.startsWith('package:$appPackage');

    if (isStandardLibrary) {
      return IgnoredStandardLibrary(import);
    }

    if (isPackageDependency && !isAppPackageDependency) {
      return IgnoredExternalPackage(import);
    }

    final isRelative = !isAppPackageDependency;
    final isNested = import.contains('/');

    if (isRelative && isNested) {
      return DisallowedNestedImport(import);
    }

    return ValidImport(ImportedDependency._(source, import));
  }
}

class SourceFile {
  final String path;

  SourceFile(this.path);
}


sealed class DependencyCreationResult {}

class ValidImport implements DependencyCreationResult {
  final ImportedDependency dependency;

  ValidImport(this.dependency);
}

class IgnoredStandardLibrary implements DependencyCreationResult {
  final String import;

  IgnoredStandardLibrary(this.import);
}

class IgnoredExternalPackage implements DependencyCreationResult {
  final String import;

  IgnoredExternalPackage(this.import);
}

class DisallowedNestedImport implements DependencyCreationResult {
  final String import;

  DisallowedNestedImport(this.import);
}
