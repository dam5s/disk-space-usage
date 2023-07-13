import 'package:disk_space_usage/binary_tree.dart';
import 'package:disk_space_usage/disk_item_presenter.dart';
import 'package:disk_space_usage/tree_map.dart';
import 'package:flutter/material.dart';

import 'disk_item.dart';
import 'disk_item_colors.dart';
import 'disk_item_navigation.dart';

const double _padding = 4;

class _DiskItemBranchWidget extends StatelessWidget {
  final BinaryTree<ParentedDiskItem> left;
  final BinaryTree<ParentedDiskItem> right;
  final DiskItemColors colors;
  final void Function(ParentedDiskItem) onDiskItemSelected;

  const _DiskItemBranchWidget({
    required this.left,
    required this.right,
    required this.colors,
    required this.onDiskItemSelected,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final leftWeight = left.weight();
        final rightWeight = right.weight();
        final totalWeight = leftWeight + rightWeight;

        final BoxConstraints(:maxWidth, :maxHeight) = constraints;

        Widget sizedChildWidget({
          required double width,
          required double height,
          required BinaryTree<ParentedDiskItem> tree,
        }) {
          if (width < 50 || height < 50) {
            return SizedBox(width: width, height: height, child: _BlankDiskItem(colors: colors));
          }

          return SizedBox(
            width: width,
            height: height,
            child: _DiskItemTreeWidget(tree: tree, colors: colors, onDiskItemSelected: onDiskItemSelected),
          );
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
  final BinaryTree<ParentedDiskItem> tree;
  final DiskItemColors colors;
  final void Function(ParentedDiskItem) onDiskItemSelected;

  const _DiskItemTreeWidget({required this.tree, required this.colors, required this.onDiskItemSelected});

  @override
  Widget build(BuildContext context) => switch (tree) {
        Leaf(data: final diskItem) => DiskItemWidget(
            parentedDiskItem: diskItem,
            colors: colors,
            onDiskItemSelected: onDiskItemSelected,
          ),
        Branch(left: final leftTree, right: final rightTree) => _DiskItemBranchWidget(
            left: leftTree,
            right: rightTree,
            colors: colors,
            onDiskItemSelected: onDiskItemSelected,
          ),
      };
}

class _DiskItemDetailsWidget extends StatelessWidget {
  final ParentedDiskItem parentedDiskItem;
  final DiskItemColors colors;
  final void Function(ParentedDiskItem) onDiskItemSelected;

  const _DiskItemDetailsWidget(
      {required this.parentedDiskItem, required this.colors, required this.onDiskItemSelected});

  List<ParentedDiskItem> parentAllChildren(List<DiskItem> children) =>
      children.map((c) => ParentedDiskItem(c, parent: parentedDiskItem)).toList();

  TreeMap<ParentedDiskItem> _buildTreeMap(List<ParentedDiskItem> items) =>
      createTreeMap(items.map((i) => Leaf(i, i.diskItem.size)).toList());

  @override
  Widget build(BuildContext context) => switch (parentedDiskItem.diskItem.type) {
        FileDiskItemType() => const SizedBox.shrink(),
        LinkDiskItemType() => const SizedBox.shrink(),
        DirectoryDiskItemType(children: final c) => _DiskItemTreeWidget(
            tree: _buildTreeMap(parentAllChildren(c)).root,
            colors: colors,
            onDiskItemSelected: onDiskItemSelected,
          ),
      };
}

BoxDecoration _border(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return BoxDecoration(border: Border.all(color: colorScheme.outline.withOpacity(0.15)));
}

class _BlankDiskItem extends StatelessWidget {
  final DiskItemColors colors;

  const _BlankDiskItem({required this.colors});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(_padding),
        child: Container(
          decoration: _border(context),
          child: ColoredBox(color: colors.next(context)),
        ),
      );
}

class DiskItemWidget extends StatelessWidget {
  final ParentedDiskItem parentedDiskItem;
  final DiskItemColors colors;
  final void Function(ParentedDiskItem selectedDiskItem) onDiskItemSelected;

  const DiskItemWidget(
      {super.key, required this.parentedDiskItem, required this.colors, required this.onDiskItemSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final diskItem = parentedDiskItem.diskItem;

    return Container(
      padding: const EdgeInsets.all(_padding),
      child: Container(
        decoration: _border(context),
        child: ColoredBox(
          color: colors.next(context),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const LinearBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(_padding * 2)),
              ),
              onPressed: () => onDiskItemSelected(parentedDiskItem),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    diskItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall,
                  ),
                  Text(
                    DiskItemPresenter.sizeText(diskItem.size),
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
                child: _DiskItemDetailsWidget(
                  parentedDiskItem: parentedDiskItem,
                  colors: colors,
                  onDiskItemSelected: onDiskItemSelected,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
