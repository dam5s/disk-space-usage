import 'package:flutter/material.dart';

import 'basic_widgets.dart';
import 'disk_item_navigation.dart';

class DirectoryNavigationBar extends StatefulWidget {
  final ParentedDiskItem diskItem;
  final void Function(ParentedDiskItem) navigateToDiskItem;
  final void Function() navigateHome;

  const DirectoryNavigationBar({
    super.key,
    required this.diskItem,
    required this.navigateToDiskItem,
    required this.navigateHome,
  });

  @override
  State<StatefulWidget> createState() => _DirectoryNavigationBarState();
}

class _DirectoryNavigationBarState extends State<DirectoryNavigationBar> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {}

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Row(children: _buildNavigationItems()),
      );

  List<Widget> _buildNavigationItems() {
    final itemsInNav = _retrieveDiskItems();

    final navChildren = itemsInNav
        .expand(
          (navItem) => <Widget>[
            const Text('/'),
            SquareTextButton(
              padding: 20,
              onPressed: () => widget.navigateToDiskItem(navItem),
              child: Text(navItem.diskItem.name),
            ),
          ],
        )
        .toList();

    navChildren.insert(
      0,
      SquareTextButton(
        padding: 20,
        onPressed: widget.navigateHome,
        child: const Icon(Icons.home),
      ),
    );
    return navChildren;
  }

  List<ParentedDiskItem> _retrieveDiskItems() {
    final itemsInNav = <ParentedDiskItem>[];
    ParentedDiskItem? item = widget.diskItem;

    while (item != null) {
      itemsInNav.insert(0, item);
      item = item.parent;
    }
    return itemsInNav;
  }
}
