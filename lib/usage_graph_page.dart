import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'disk_item.dart';
import 'disk_item_colors.dart';
import 'disk_item_widget.dart';

class UsageGraphPage extends StatefulWidget {
  const UsageGraphPage({super.key});

  @override
  State<UsageGraphPage> createState() => _UsageGraphPageState();
}

class _UsageGraphPageState extends State<UsageGraphPage> {
  Future<DiskItem>? _diskItemFuture;

  final _logger = Logger();

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
          children: [_diskItemFuture == null ? _selectFolderButton() : _diskItemFutureView()],
        ),
      ),
    );
  }

  Widget _selectFolderButton() => MaterialButton(
        child: const Text('Select folder'),
        onPressed: () async {
          final String? directoryPath = await getDirectoryPath();

          setState(() {
            if (directoryPath != null) {
              _diskItemFuture = loadDirectory(directoryPath);
            } else {
              _diskItemFuture = null;
            }
          });
        },
      );

  void _diskItemSelected(DiskItem selectedDiskItem) {
    _logger.d(selectedDiskItem);
  }

  Widget _diskItemFutureView() => FutureBuilder(
      future: _diskItemFuture,
      builder: (context, snapshot) {
        final data = snapshot.data;
        return data == null ? _loadingWidget() : _loadedWidget(context, data);
      });

  Expanded _loadedWidget(BuildContext context, DiskItem data) => Expanded(
        child: ColoredBox(
          color: Theme.of(context).colorScheme.tertiary,
          child: DiskItemWidget(
            diskItem: data,
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
