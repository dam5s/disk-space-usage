import 'binary_tree.dart';

class TreeMap<T> {
  final BinaryTree<T> root;

  const TreeMap(this.root);
}

TreeMap<T> createTreeMap<T>(List<Leaf<T>> leaves) {
  final sortedLeaves = List.of(leaves as List<BinaryTree<T>>).toList()
    ..sort((a, b) => a.weight() - b.weight());

  final sortedTrees = <BinaryTree<T>>[];

  bool treeIsCompleted() {
    if (sortedTrees.length == 1) {
      return sortedTrees[0].leafCount() == leaves.length;
    }
    return false;
  }

  BinaryTree<T>? takeLightestTree() => switch ((sortedLeaves, sortedTrees)) {
        ([], []) => null,
        ([], [...]) => sortedTrees.removeAt(0),
        ([...], []) => sortedLeaves.removeAt(0),
        ([final leaf, ...], [final tree, ...]) =>
          leaf.weight() < tree.weight() ? sortedLeaves.removeAt(0) : sortedTrees.removeAt(0),
      };

  BinaryTree<T>? left;

  while (!treeIsCompleted()) {
    final lightestTree = takeLightestTree();

    if (left == null && lightestTree == null) {
      continue;
    }

    if (left != null && lightestTree != null) {
      sortedTrees.add(Branch(left, lightestTree));
      left = null;
      continue;
    }

    if (lightestTree != null) {
      left = lightestTree;
      continue;
    }

    if (left != null) {
      sortedTrees.add(left);
      left = null;
      continue;
    }
  }

  return TreeMap(sortedTrees[0]);
}
