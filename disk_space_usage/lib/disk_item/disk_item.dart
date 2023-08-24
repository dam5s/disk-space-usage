import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

sealed class DiskItemType {}

class FileDiskItemType implements DiskItemType {}

class DirectoryDiskItemType implements DiskItemType {
  final List<DiskItem> children;

  DirectoryDiskItemType(this.children);
}

class LinkDiskItemType implements DiskItemType {}

class DiskItem {
  final String name;
  final int size;
  final DiskItemType type;

  DiskItem(this.name, this.size, this.type);
}

int _size(List<DiskItem> items) => items
    .map((child) => child.size)
    .fold(0, (sum, childSize) => sum + childSize);

final _logger = Logger();

Future<DiskItem> _loadFileSystemEntity(
  void Function(String path) onProgress,
  FileSystemEntity entity,
) async {
  final parentPath = entity.parent.absolute.path;
  final entityPath = entity.absolute.path;
  final name = entityPath.replaceFirst('$parentPath/', '');

  onProgress(entityPath);

  if (FileSystemEntity.isLinkSync(entityPath)) {
    return DiskItem(name, 0, LinkDiskItemType());
  }

  switch (entity) {
    case File():
      {
        final fileStat = await entity.stat();
        return DiskItem(name, fileStat.size, FileDiskItemType());
      }
    case Directory():
      {
        var children = <DiskItem>[];

        try {
          children = await entity
              .list()
              .asyncMap(
                (e) => _loadFileSystemEntity(onProgress, e),
              )
              .toList();
        } on Exception {
          _logger.w('Failed to read children of $entityPath');
        }

        return DiskItem(
          name,
          _size(children),
          DirectoryDiskItemType(children),
        );
      }
    case Link():
      return DiskItem(name, 0, LinkDiskItemType());

    default:
      return throw Exception('Unsupported FileSystemEntity type');
  }
}

(Stream<String>, Future<DiskItem>) loadDirectory(String path) {
  final progressController = StreamController<String>();
  final dir = Directory(path);

  var lastEvent = DateTime.now().subtract(const Duration(minutes: 1));

  onProgress(String absolutePath) {
    const debounceDuration = Duration(milliseconds: 50);

    final now = DateTime.now();
    final threshold = now.subtract(debounceDuration);

    if (lastEvent.isBefore(threshold)) {
      progressController.sink.add(absolutePath.replaceFirst('$path/', ''));
      lastEvent = now;
    }
  }

  return (progressController.stream, _loadFileSystemEntity(onProgress, dir));
}
