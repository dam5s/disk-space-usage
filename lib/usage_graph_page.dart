import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import 'disk_item.dart';
import 'disk_item_widget.dart';

class UsageGraphPage extends StatefulWidget {
  const UsageGraphPage({super.key});

  @override
  State<UsageGraphPage> createState() => _UsageGraphPageState();
}

class _UsageGraphPageState extends State<UsageGraphPage> {
  Future<DiskItem>? _diskItemFuture;

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

  Widget _diskItemFutureView() => FutureBuilder(
      future: _diskItemFuture,
      builder: (context, snapshot) {
        final data = snapshot.data;
        return data == null ? _loadingView() : Expanded(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.tertiary,
              child: DiskItemWidget(diskItem: data, colors: DiskItemColors()),
            )
        );
      });

  Widget _loadingView() => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 128),
        child: const SizedBox(width: 32, height: 32, child: CircularProgressIndicator()),
      );
}
