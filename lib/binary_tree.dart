sealed class BinaryTree<T> {}

class Leaf<T> implements BinaryTree<T> {
  final T data;
  final int weight;

  const Leaf(this.data, this.weight);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Leaf &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          weight == other.weight;

  @override
  int get hashCode => data.hashCode ^ weight.hashCode;
}

class Branch<T> implements BinaryTree<T> {
  final BinaryTree<T> left;
  final BinaryTree<T> right;

  const Branch(this.left, this.right);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Branch &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          right == other.right;

  @override
  int get hashCode => left.hashCode ^ right.hashCode;
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
