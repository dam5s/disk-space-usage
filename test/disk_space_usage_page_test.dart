import 'package:disk_space_usage/app_dependencies.dart';
import 'package:disk_space_usage/directory_selector.dart';
import 'package:disk_space_usage/disk_item.dart';
import 'package:disk_space_usage/disk_item_navigation.dart';
import 'package:disk_space_usage/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'test_support/test_directory_selector.dart';

void main() {
  testWidgets('Loading some disk items', (WidgetTester tester) async {
    final selected = SelectedDirectory(
        loadingPaths: Stream.value('some/path'),
        diskItemFuture: Future.value(ParentedDiskItem(
          DiskItem(
              'root',
              100,
              DirectoryDiskItemType(
                [
                  DiskItem(
                      'sub-dir',
                      50,
                      DirectoryDiskItemType(
                        [
                          DiskItem('A', 40, FileDiskItemType()),
                          DiskItem('B', 40, FileDiskItemType()),
                        ],
                      )),
                  DiskItem('C', 50, FileDiskItemType()),
                ],
              )),
          parent: null,
        )));
    final selector = TestDirectorySelector(selected: selected);

    await tester.pumpWidget(Provider<AppDependencies>(
      create: (_) => AppDependencies(directorySelector: selector),
      child: const DiskSpaceUsageApp(),
    ));

    expect(find.text('Select folder'), findsOneWidget);

    await tester.tap(find.text('Select folder'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text('root'), findsNWidgets(2));
    expect(find.text('sub-dir'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    expect(find.text('100 B'), findsOneWidget);
    expect(find.text('40 B'), findsNWidgets(2));
    expect(find.text('50 B'), findsNWidgets(2));
  });
}
