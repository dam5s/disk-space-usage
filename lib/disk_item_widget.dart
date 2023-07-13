import 'package:disk_space_usage/binary_tree.dart';
import 'package:disk_space_usage/tree_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'disk_item.dart';

const double _padding = 4;

class _DiskItemBranchWidget extends StatelessWidget {
  final BinaryTree<DiskItem> left;
  final BinaryTree<DiskItem> right;
  final DiskItemColors colors;

  const _DiskItemBranchWidget({required this.left, required this.right, required this.colors});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final leftWeight = left.weight();
        final rightWeight = right.weight();
        final totalWeight = leftWeight + rightWeight;

        final BoxConstraints(:maxWidth, :maxHeight) = constraints;

        Widget sizedChildWidget({required double width, required double height, required BinaryTree<DiskItem> tree}) {
          if (width < 50 || height < 50) {
            return SizedBox(width: width, height: height, child: _BlankDiskItem(colors: colors));
          }

          return SizedBox(width: width, height: height, child: _DiskItemTreeWidget(tree: tree, colors: colors));
        }

        if (maxWidth > maxHeight) {
          final leftWidth = maxWidth * leftWeight / totalWeight;
          final rightWidth = maxWidth * rightWeight / totalWeight;

          return Row(
            children: [
              sizedChildWidget(width: leftWidth, height: maxHeight, tree: left),
              sizedChildWidget(width: rightWidth, height: maxHeight, tree: right),
            ],
          );
        } else {
          final leftHeight = maxHeight * leftWeight / totalWeight;
          final rightHeight = maxHeight * rightWeight / totalWeight;

          return Column(
            children: [
              sizedChildWidget(width: maxWidth, height: leftHeight, tree: left),
              sizedChildWidget(width: maxWidth, height: rightHeight, tree: right),
            ],
          );
        }
      });
}

class _DiskItemTreeWidget extends StatelessWidget {
  final BinaryTree<DiskItem> tree;
  final DiskItemColors colors;

  const _DiskItemTreeWidget({required this.tree, required this.colors});

  @override
  Widget build(BuildContext context) => switch (tree) {
        Leaf(data: final diskItem) => DiskItemWidget(diskItem: diskItem, colors: colors),
        Branch(left: final leftTree, right: final rightTree) =>
          _DiskItemBranchWidget(left: leftTree, right: rightTree, colors: colors),
      };
}

class _DiskItemDetailsWidget extends StatelessWidget {
  final DiskItem diskItem;
  final DiskItemColors colors;

  const _DiskItemDetailsWidget({required this.diskItem, required this.colors});

  TreeMap<DiskItem> _buildTreeMap(List<DiskItem> items) => createTreeMap(items.map((i) => Leaf(i, i.size)).toList());

  @override
  Widget build(BuildContext context) => switch (diskItem.type) {
        FileDiskItemType() => const SizedBox.shrink(),
        LinkDiskItemType() => const SizedBox.shrink(),
        DirectoryDiskItemType(children: final c) => _DiskItemTreeWidget(tree: _buildTreeMap(c).root, colors: colors),
      };
}

BoxDecoration _border(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return BoxDecoration(border: Border.all(color: colorScheme.outline.withOpacity(0.15)));
}

class DiskItemColors {
  var _currentIndex = -1;

  Color next(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    _currentIndex++;

    return switch (_currentIndex % 7) {
      0 => colorScheme.background,
      1 => colorScheme.surface,
      2 => colorScheme.surfaceVariant,
      3 => colorScheme.surfaceTint,
      4 => colorScheme.secondaryContainer,
      5 => colorScheme.tertiaryContainer,
      _ => colorScheme.primaryContainer,
    }.withOpacity(0.25);
  }
}

class _BlankDiskItem extends StatelessWidget {
  final DiskItemColors colors;

  const _BlankDiskItem({required this.colors});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(_padding),
      child: Container(
        decoration: _border(context),
        child: ColoredBox(
          color: colors.next(context),
        ),
      ),
    );
  }
}

class DiskItemWidget extends StatelessWidget {
  final DiskItem diskItem;
  final DiskItemColors colors;

  const DiskItemWidget({super.key, required this.diskItem, required this.colors});

  String _sizeText(int bytes) {
    const oneKB = 1024;
    const oneMB = oneKB * 1024;
    const oneGB = oneMB * 1024;
    final formatter = NumberFormat('###.0#', 'en_US');

    return switch (bytes) {
      _ when bytes > oneGB => '${formatter.format(bytes / oneGB)} GB',
      _ when bytes > oneMB => '${formatter.format(bytes / oneMB)} MB',
      _ when bytes > oneKB => '${formatter.format(bytes / oneKB)} KB',
      _ => '${formatter.format(bytes / oneKB)} B',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(_padding),
      child: Container(
        decoration: _border(context),
        child: ColoredBox(
          color: colors.next(context),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.fromLTRB(_padding, _padding / 2, _padding, _padding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diskItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall,
                  ),
                  Text(
                    _sizeText(diskItem.size),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
                child: ColoredBox(
                  color: colorScheme.background.withOpacity(0.25),
                  child: _DiskItemDetailsWidget(diskItem: diskItem, colors: colors),
                ) ,
            ),
          ]),
        ),
      ),
    );
  }
}
