import 'dart:io';

import 'core_extensions.dart';

sealed class DiskItemType {}

class FileDiskItemType implements DiskItemType {}

class DirectoryDiskItemType implements DiskItemType {
  final String path;
  final List<DiskItem> children;

  DirectoryDiskItemType(this.path, this.children);
}

class LinkDiskItemType implements DiskItemType {}

class DiskItem {
  final String name;
  final int size;
  final DiskItemType type;

  DiskItem(this.name, this.size, this.type);
}

int _size(List<DiskItem> items) =>
  items.map((child) => child.size).fold(0, (sum, childSize) => sum + childSize);

Future<DiskItem?> _loadFileSystemEntity(FileSystemEntity entity) async {
  final parentPath = entity.parent.absolute.path;
  final entityPath = entity.absolute.path;
  final name = entityPath.replaceFirst('$parentPath/', '');

  switch (entity) {
    case File():
      {
        final fileStat = await entity.stat();
        return DiskItem(name, fileStat.size, FileDiskItemType());
      }
    case Directory():
      {
        final maybeChildren = await entity.list()
            .asyncMap(_loadFileSystemEntity)
            .toList();

        final children = maybeChildren.filter((e) => e != null).cast<DiskItem>().toList();

        return DiskItem(
            name,
            _size(children),
            DirectoryDiskItemType(entity.absolute.path, children),
        );
      }
    case Link():
      return DiskItem(name, 0, LinkDiskItemType());

    default:
      return null;
  }
}

Future<DiskItem> loadDirectory(String path) async {
  final dir = Directory(path);
  final entity = await _loadFileSystemEntity(dir);
  return entity!;
}
