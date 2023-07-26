import 'dart:async';
import 'dart:io';

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

int _size(List<DiskItem> items) => items.map((child) => child.size).fold(0, (sum, childSize) => sum + childSize);

Future<DiskItem> _loadFileSystemEntity(
  void Function(String path) onProgress,
  FileSystemEntity entity,
) async {
  final parentPath = entity.parent.absolute.path;
  final entityPath = entity.absolute.path;
  final name = entityPath.replaceFirst('$parentPath/', '');

  onProgress(entityPath);

  switch (entity) {
    case File():
      {
        final fileStat = await entity.stat();
        return DiskItem(name, fileStat.size, FileDiskItemType());
      }
    case Directory():
      {
        final children = await entity.list().asyncMap((e) => _loadFileSystemEntity(onProgress, e)).toList();

        return DiskItem(
          name,
          _size(children),
          DirectoryDiskItemType(entity.absolute.path, children),
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

  onProgress(String absolutePath) {
    progressController.sink.add(absolutePath.replaceFirst('$path/', ''));
  }

  return (progressController.stream, _loadFileSystemEntity(onProgress, dir));
}
