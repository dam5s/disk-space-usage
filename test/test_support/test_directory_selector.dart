import 'package:disk_space_usage/directory_selector.dart';

class TestDirectorySelector implements DirectorySelector {

  final SelectedDirectory? selected;

  TestDirectorySelector({required this.selected});

  @override
  Future<SelectedDirectory?> getDirectoryPath() async => selected;
}
