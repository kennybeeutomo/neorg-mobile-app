abstract class Node {}

class DocumentNode extends Node {
  final List<Node> children;

  DocumentNode(this.children);
}

class HeadingNode extends Node {
  final int level;
  final String text;

  HeadingNode({required this.level, required this.text});
}

class ParagraphNode extends Node {
  final String text;

  ParagraphNode(this.text);
}

class BulletListNode extends Node {
  final List<BulletListItemNode> items;

  BulletListNode(this.items);
}

class BulletListItemNode extends Node {
  final String text;

  BulletListItemNode(this.text);
}

class CodeBlockNode extends Node {
  final String language;
  final String code;

  CodeBlockNode({required this.language, required this.code});
}
