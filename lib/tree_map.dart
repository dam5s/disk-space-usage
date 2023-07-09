import 'binary_tree.dart';

class TreeMap<T> {
  final BinaryTree<T> root;

  const TreeMap(this.root);
}


TreeMap<T> createTreeMap<T>(List<Leaf<T>> leaves) {
  final sortedLeaves = List.of(leaves as List<BinaryTree<T>>)
    .toList()
    // TODO check this is sorting correctly
    ..sort((a, b) => a.weight() - b.weight());

  final sortedTrees = <BinaryTree<T>>[];

  bool treeIsCompleted() {
    if (sortedTrees.length == 1) {
      return sortedTrees[0].leafCount() == leaves.length;
    }
    return false;
  }

  BinaryTree<T>? takeLightestTree() {
    // TODO see if we can do pattern matching on lists here

    if (sortedLeaves.isEmpty && sortedTrees.isEmpty) {
      return null;
    }

    if (sortedLeaves.isEmpty) {
      // TODO see if we should change sorting order if removeLast is more efficient
      return sortedTrees.removeAt(0);
    }

    if (sortedTrees.isEmpty) {
      return sortedLeaves.removeAt(0);
    }

    if (sortedLeaves[0].weight() < sortedTrees[0].weight()) {
      return sortedLeaves.removeAt(0);
    } else {
      return sortedTrees.removeAt(0);
    }
  }

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
