import 'module_dependency.dart';

class ImportedDependency {
  final String appPackage;
  final SourceFile source;
  final String import;
  final Module sourceModule;
  final Module importedModule;

  ImportedDependency._(
    this.appPackage,
    this.source,
    this.import,
    this.sourceModule,
    this.importedModule,
  );

  @override
  String toString() => 'src: ${source.path}, import: $import';

  static DependencyCreationResult tryCreate(
    String appPackage,
    SourceFile source,
    String importLine,
  ) {
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

    if (isRelative) {
      return IgnoredInnerImport(import);
    }

    final sourceModule = _sourceModule(appPackage, source);
    final importedModule = _importedModule(appPackage, import, sourceModule);

    if (importedModule == sourceModule) {
      return IgnoredInnerImport(import);
    }

    return ValidImport(ImportedDependency._(
      appPackage,
      source,
      import,
      sourceModule,
      importedModule,
    ));
  }

  static Module _sourceModule(String appPackage, SourceFile source) {
    final components = source.path.split('/')
      ..removeLast()
      ..removeAt(0)
      ..insert(0, appPackage);
    final path = components.join('/');

    return Module(path);
  }

  static Module _importedModule(
    String appPackage,
    String import,
    Module sourceModule,
  ) {
    final components = import.replaceFirst('package:', '').split('/')..removeLast();

    return Module(components.join('/'));
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

class IgnoredInnerImport implements DependencyCreationResult {
  final String import;

  IgnoredInnerImport(this.import);
}
