import 'package:disk_space_usage/tree/binary_tree.dart';
import 'package:disk_space_usage/tree/tree_map.dart';
import 'package:flutter_test/flutter_test.dart';

extension Record<T> on BinaryTree<T> {
  dynamic toRecord() => switch (this) {
        Leaf(data: final d, weight: final w) => (data: d, weight: w),
        Branch(left: final l, right: final r) => (
            left: l.toRecord(),
            right: r.toRecord(),
          )
      };
}

void main() {
  test('createTreeMap', () {
    final leaves = [
      const Leaf('File A', 9),
      const Leaf('File C', 11),
      const Leaf('File B', 10),
      const Leaf('File E', 30),
      const Leaf('File D', 15),
    ];

    final treeMap = createTreeMap(leaves);

    const expectedTreeRoot = Branch(
      Leaf('File E', 30),
      Branch(
        Branch(
          Leaf('File A', 9),
          Leaf('File B', 10),
        ),
        Branch(
          Leaf('File C', 11),
          Leaf('File D', 15),
        ),
      ),
    );

    expect(treeMap.root.toRecord(), equals(expectedTreeRoot.toRecord()));
  });

  test('createTreeMap, single leaf', () {
    final leaves = [const Leaf('File A', 9)];

    final treeMap = createTreeMap(leaves);

    const expectedTree = Leaf('File A', 9);

    expect(treeMap.root, equals(expectedTree));
  });
}
