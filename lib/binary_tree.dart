sealed class BinaryTree<T> {}

class Leaf<T> implements BinaryTree<T> {
  final T data;
  final int weight;

  const Leaf(this.data, this.weight);
}

class Branch<T> implements BinaryTree<T> {
  final BinaryTree<T> left;
  final BinaryTree<T> right;

  const Branch(this.left, this.right);
}

extension BinaryTreeExtensions<T> on BinaryTree<T> {

  int weight() => switch (this) {
    Leaf(data: _, weight: final w) => w,
    Branch(left: final l, right: final r) => l.weight() + r.weight(),
  };

  int leafCount() => switch (this) {
    Leaf() => 1,
    Branch(left: final l, right: final r) => l.leafCount() + r.leafCount(),
  };
}
