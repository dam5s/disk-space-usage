import 'package:disk_space_usage/directory_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppDependencies {
  final DirectorySelector directorySelector;

  AppDependencies({required this.directorySelector});
}

extension AppDependenciesGetter on BuildContext {
  AppDependencies appDependencies() => Provider.of<AppDependencies>(this, listen: false);
}
