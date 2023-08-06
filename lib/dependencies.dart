import 'package:disk_space_usage/directory_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Dependencies {
  final DirectorySelector directorySelector;

  Dependencies({required this.directorySelector});
}

extension DependenciesGetter on BuildContext {
  Dependencies appDependencies() => Provider.of<Dependencies>(this, listen: false);
}
