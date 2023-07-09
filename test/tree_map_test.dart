import 'package:disk_space_usage/binary_tree.dart';
import 'package:disk_space_usage/tree_map.dart';
import 'package:flutter_test/flutter_test.dart';

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

    expect(treeMap.root, equals(expectedTreeRoot));
  });

  test('createTreeMap, single leaf', () {
    final leaves = [const Leaf('File A', 9)];

    final treeMap = createTreeMap(leaves);

    const expectedTree = Leaf('File A', 9);

    expect(treeMap.root, equals(expectedTree));
  });
}
