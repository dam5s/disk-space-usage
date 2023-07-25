import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'disk_space_usage_page.dart';

void main() {
  runApp(const DiskSpaceUsageApp());

  doWhenWindowReady(() {
    appWindow
      ..minSize = const Size(600, 500)
      ..alignment = Alignment.center
      ..title = 'Disk Space Usage'
      ..show();
  });
}

class DiskSpaceUsageApp extends StatelessWidget {
  const DiskSpaceUsageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disk Space Usage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: MediaQuery.of(context).platformBrightness,
        ),
        useMaterial3: true,
      ),
      home: const DiskSpaceUsagePage(),
    );
  }
}
