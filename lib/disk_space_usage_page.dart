import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import 'directory_navigation_bar.dart';
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
  Stream<String>? _loadingStream;

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
      body: _diskItemFuture == null ? _selectDirectoryWidget() : _diskItemFutureWidget(),
    );
  }

  Widget _selectDirectoryWidget() => Center(
        child: ElevatedButton(
          child: const Text('Select folder'),
          onPressed: () async {
            final String? directoryPath = await getDirectoryPath();

            setState(() {
              if (directoryPath != null) {
                final (loadingStream, itemFuture) = loadDirectory(directoryPath);
                _loadingStream = loadingStream;
                _diskItemFuture = itemFuture.then((diskItem) => ParentedDiskItem(diskItem));
              } else {
                _diskItemFuture = null;
              }
            });
          },
        ),
      );

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

  Widget _diskItemFutureWidget() => FutureBuilder(
        future: _diskItemFuture,
        builder: (context, snapshot) {
          final data = snapshot.data;
          return data == null ? _loadingWidget() : _loadedWidget(context, data);
        },
      );

  Widget _loadingWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<String>(
              stream: _loadingStream ?? const Stream.empty(),
              builder: (context, snapshot) {
                final path = snapshot.data ?? '';
                return Text(path, maxLines: 1, overflow: TextOverflow.ellipsis);
              },
            ),
            const SizedBox(height: 8),
            const SizedBox(width: 32, height: 32, child: CircularProgressIndicator()),
          ],
        ),
      );

  Widget _loadedWidget(BuildContext context, ParentedDiskItem diskItem) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DirectoryNavigationBar(
            diskItem: diskItem,
            navigateToDiskItem: _navigateToDiskItem,
            navigateHome: _navigateHome,
          ),
          Expanded(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: DiskItemWidget(
                parentedDiskItem: diskItem,
                onDiskItemSelected: _navigateToDiskItem,
                colors: DiskItemColors(),
              ),
            ),
          )
        ],
      );
}
