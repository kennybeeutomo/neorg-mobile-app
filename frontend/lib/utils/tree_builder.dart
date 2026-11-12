import '../models/norg_file.dart';
import '../models/tree_node.dart';

class TreeBuilder {
  static List<TreeNode> build(List<NorgFile> files) {
    final roots = <TreeNode>[];

    for (final file in files) {
      final parts = file.filepath.split('/');

      List<TreeNode> current = roots;

      for (int i = 0; i < parts.length; i++) {
        final part = parts[i];

        final isLast = i == parts.length - 1;

        TreeNode? node;

        try {
          node = current.firstWhere((e) => e.name == part);
        } catch (_) {
          node = null;
        }

        if (node == null) {
          node = TreeNode(
            name: part,
            isDirectory: !isLast,
            file: isLast ? file : null,
          );

          current.add(node);
        }

        current = node.children;
      }
    }

    return roots;
  }
}
