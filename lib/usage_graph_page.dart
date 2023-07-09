import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UsageGraphPage extends StatefulWidget {
  const UsageGraphPage({super.key});

  @override
  State<UsageGraphPage> createState() => _UsageGraphPageState();
}

class _UsageGraphPageState extends State<UsageGraphPage> {

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
          children: [
            Container(
              color: colorScheme.secondaryContainer,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: MaterialButton(
                child: const Text('Select folder'),
                onPressed: () async {
                  final String? directoryPath = await getDirectoryPath();
                  Logger().d(directoryPath);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
