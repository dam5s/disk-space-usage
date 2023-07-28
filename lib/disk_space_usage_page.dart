import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:disk_space_usage/app_dependencies.dart';
import 'package:flutter/material.dart';

import 'directory_navigation_bar.dart';
import 'directory_selector.dart';
import 'disk_item_colors.dart';
import 'disk_item_navigation.dart';
import 'disk_item_widget.dart';

class DiskSpaceUsagePage extends StatefulWidget {
  const DiskSpaceUsagePage({super.key});

  @override
  State<DiskSpaceUsagePage> createState() => _DiskSpaceUsagePageState();
}

class _DiskSpaceUsagePageState extends State<DiskSpaceUsagePage> {
  SelectedDirectory? _selectedDirectory;

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
      body: _selectedDirectory == null
          ? _selectDirectoryWidget()
          : _diskItemFutureWidget(_selectedDirectory!),
    );
  }

  Widget _selectDirectoryWidget() => Center(
        child: ElevatedButton(
          child: const Text('Select folder'),
          onPressed: () async {
            final appDependencies = context.appDependencies();
            final selector = appDependencies.directorySelector;
            final selected = await selector.getDirectoryPath();

            setState(() {
              _selectedDirectory = selected;
            });
          },
        ),
      );

  void _navigateHome() {
    setState(() {
      _selectedDirectory = null;
    });
  }

  void _navigateToDiskItem(ParentedDiskItem selectedDiskItem) {
    final selected = _selectedDirectory;

    if (selected == null) {
      return;
    }

    setState(() {
      _selectedDirectory = selected.copy(diskItemFuture: Future.value(selectedDiskItem));
    });
  }

  Widget _diskItemFutureWidget(SelectedDirectory selectedDirectory) => FutureBuilder(
        future: selectedDirectory.diskItemFuture,
        builder: (context, snapshot) {
          final data = snapshot.data;
          return data == null
              ? _loadingWidget(selectedDirectory.loadingPaths)
              : _loadedWidget(context, data);
        },
      );

  Widget _loadingWidget(Stream<String> loadingStream) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<String>(
              stream: loadingStream,
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
