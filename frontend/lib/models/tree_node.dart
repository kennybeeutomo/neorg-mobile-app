import 'norg_file.dart';

class TreeNode {
  final String name;
  final bool isDirectory;

  final List<TreeNode> children = [];

  NorgFile? file;

  TreeNode({
    required this.name,
    required this.isDirectory,
    this.file,
  });
}
