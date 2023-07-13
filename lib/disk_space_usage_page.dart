import 'package:bitsdojo_window/bitsdojo_window.dart';
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
        MaterialButton(
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
      ];

  void _diskItemSelected(ParentedDiskItem selectedDiskItem) {
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

    return Row(
      children: itemsInNav
          .expand((navItem) => <Widget>[
                const Text('/'),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const LinearBorder()),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  ),
                  onPressed: () => _diskItemSelected(navItem),
                  child: Text(navItem.diskItem.name),
                ),
              ])
          .toList(),
    );
  }

  Widget _loadedWidget(BuildContext context, ParentedDiskItem diskItem) => Expanded(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: DiskItemWidget(
            parentedDiskItem: diskItem,
            onDiskItemSelected: _diskItemSelected,
            colors: DiskItemColors(),
          ),
        ),
      );

  Widget _loadingWidget() => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 128),
        child: const SizedBox(width: 32, height: 32, child: CircularProgressIndicator()),
      );
}
