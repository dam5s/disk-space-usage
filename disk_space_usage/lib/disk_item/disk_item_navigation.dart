import 'disk_item.dart';

class ParentedDiskItem {
  final DiskItem diskItem;
  final ParentedDiskItem? parent;

  ParentedDiskItem(this.diskItem, {this.parent});
}
