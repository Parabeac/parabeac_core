/// Class that represents a generic Component Isolation Node.
///
/// For instance, Widgetbook may have Categories, Folders, etc.,
/// while Dashbook has Stories and Chapters. This node can represent
/// these in a generic way.
abstract class IsolationNode {
  String name;

  List<IsolationNode> children;

  /// Generates a string representation of how the
  /// [IsolationNode] should be printed.
  String generate();

  IsolationNode({this.children, this.name}) {
    children ??= <IsolationNode>[];
  }

  /// Adds a child to the [IsolationNode].
  void addChild(IsolationNode child) {
    children.add(child);
  }

  List<IsolationNode> getType<T extends IsolationNode>() =>
      children.whereType<T>().toList();

  /// Returns [IsolationNode] with type [T] and name [name].
  ///
  /// Returns null if no such node exists.
  IsolationNode getNamed<T extends IsolationNode>(String name) =>
      children.whereType<T>().firstWhere(
            (element) => element.name == name,
            orElse: () => null,
          );
}
