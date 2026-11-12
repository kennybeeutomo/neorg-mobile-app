import 'package:flutter/material.dart';

import 'ast.dart';

class Renderer {
  static Widget render(DocumentNode document) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: document.children.map(_renderNode).toList(),
    );
  }

  static Widget _renderNode(Node node) {
    if (node is HeadingNode) {
      return Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Text(
          node.text,
          style: TextStyle(
            fontSize: _headingSize(node.level),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (node is ParagraphNode) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          node.text,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      );
    }

    if (node is BulletListNode) {
      return Column(
        children: node.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• "),
                Expanded(child: Text(item.text)),
              ],
            ),
          );
        }).toList(),
      );
    }

    if (node is CodeBlockNode) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            node.code,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  static double _headingSize(int level) {
    switch (level) {
      case 1:
        return 32;
      case 2:
        return 28;
      case 3:
        return 24;
      case 4:
        return 20;
      default:
        return 18;
    }
  }
}
