import 'package:file_selector/file_selector.dart' as file_selector;

import 'package:disk_space_usage/disk_item/disk_item.dart';
import 'package:disk_space_usage/disk_item/disk_item_navigation.dart';

final class SelectedDirectory {
  final Stream<String> loadingPaths;
  final Future<ParentedDiskItem> diskItemFuture;

  SelectedDirectory({required this.loadingPaths, required this.diskItemFuture});

  SelectedDirectory copy({
    Stream<String>? loadingPaths,
    Future<ParentedDiskItem>? diskItemFuture,
  }) =>
      SelectedDirectory(
        loadingPaths: loadingPaths ?? this.loadingPaths,
        diskItemFuture: diskItemFuture ?? this.diskItemFuture,
      );
}

abstract class DirectorySelector {
  Future<SelectedDirectory?> getDirectoryPath();
}

final class SystemDirectorySelector implements DirectorySelector {
  @override
  Future<SelectedDirectory?> getDirectoryPath() async {
    final directoryPath = await file_selector.getDirectoryPath();
    if (directoryPath == null) {
      return null;
    }

    final (loadingStream, diskItemFuture) = loadDirectory(directoryPath);

    return SelectedDirectory(
      loadingPaths: loadingStream,
      diskItemFuture: diskItemFuture.then((diskItem) => ParentedDiskItem(diskItem)),
    );
  }
}
