import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:disk_space_usage/basic_widgets.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import 'disk_item.dart';
import 'disk_item_colors.dart';
import 'disk_item_navigation.dart';
import 'disk_item_widget.dart';

class DiskSpaceUsagePage extends StatefulWidget {
  const DiskSpaceUsagePage({super.key});

  @override
  State<DiskSpaceUsagePage> createState() => _DiskSpaceUsagePageState();
}

class _DiskSpaceUsagePageState extends State<DiskSpaceUsagePage> {
  Future<ParentedDiskItem>? _diskItemFuture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: const Text('Disk Space Usage'),
        flexibleSpace: MoveWindow(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _diskItemFuture == null ? _selectDirectoryWidgets() : _diskItemFutureWidgets(),
        ),
      ),
    );
  }

  List<Widget> _selectDirectoryWidgets() => [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 128, 0, 128),
          child: ElevatedButton(
            child: const Text('Select folder'),
            onPressed: () async {
              final String? directoryPath = await getDirectoryPath();

              setState(() {
                if (directoryPath != null) {
                  _diskItemFuture = loadDirectory(directoryPath).then((diskItem) => ParentedDiskItem(diskItem));
                } else {
                  _diskItemFuture = null;
                }
              });
            },
          ),
        )
      ];

  void _navigateHome() {
    setState(() {
      _diskItemFuture = null;
    });
  }

  void _navigateToDiskItem(ParentedDiskItem selectedDiskItem) {
    setState(() {
      _diskItemFuture = Future.value(selectedDiskItem);
    });
  }

  List<Widget> _diskItemFutureWidgets() => [
        FutureBuilder(
            future: _diskItemFuture,
            builder: (context, snapshot) {
              final data = snapshot.data;
              return data == null ? const SizedBox.shrink() : _directoryNavigationBar(data);
            }),
        FutureBuilder(
            future: _diskItemFuture,
            builder: (context, snapshot) {
              final data = snapshot.data;
              return data == null ? _loadingWidget() : _loadedWidget(context, data);
            })
      ];

  Widget _directoryNavigationBar(ParentedDiskItem currentDiskItem) {
    final itemsInNav = <ParentedDiskItem>[];
    ParentedDiskItem? item = currentDiskItem;

    while (item != null) {
      itemsInNav.insert(0, item);
      item = item.parent;
    }

    final navChildren = itemsInNav
        .expand((navItem) => <Widget>[
              const Text('/'),
              SquareTextButton(
                padding: 20,
                onPressed: () => _navigateToDiskItem(navItem),
                child: Text(navItem.diskItem.name),
              ),
            ])
        .toList();

    navChildren.insert(
      0,
      SquareTextButton(
        padding: 20,
        onPressed: _navigateHome,
        child: const Icon(Icons.home),
      ),
    );

    return Row(children: navChildren.toList());
  }

  Widget _loadedWidget(BuildContext context, ParentedDiskItem diskItem) => Expanded(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: DiskItemWidget(
            parentedDiskItem: diskItem,
            onDiskItemSelected: _navigateToDiskItem,
            colors: DiskItemColors(),
          ),
        ),
      );

  Widget _loadingWidget() => Container(
        padding: const EdgeInsets.fromLTRB(0, 128, 0, 128),
        child: const SizedBox(width: 32, height: 32, child: CircularProgressIndicator()),
      );
}
