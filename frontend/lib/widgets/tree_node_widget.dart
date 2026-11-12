import 'package:flutter/material.dart';

import '../models/tree_node.dart';
import '../models/workspace.dart';

import '../pages/editor_page.dart';

class TreeNodeWidget extends StatelessWidget {
  final TreeNode node;
  final Workspace workspace;
  final VoidCallback refresh;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.workspace,
    required this.refresh,
  });

  Future<void> _renameFile(BuildContext context) async {
    final controller = TextEditingController(text: node.file!.filepath);

    final filepath = await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Rename File'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'File path'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );

    if (filepath == null || filepath.isEmpty) {
      return;
    }

    node.file!.filepath = filepath;
    node.file!.modified = true;
    workspace.modified = true;

    refresh();
  }

  Future<void> _deleteFile(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete File'),
          content: Text('Delete "${node.file!.filepath}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    workspace.files.remove(node.file);

    workspace.modified = true;
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (!node.isDirectory) {
      return ListTile(
        leading: const Icon(Icons.description),
        title: Text(node.file!.modified ? '${node.name} *' : node.name),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditorPage(
                file: node.file!,
                onModified: () {
                  workspace.modified = true;
                  refresh();
                },
              ),
            ),
          );

          refresh();
        },
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'rename':
                _renameFile(context);
                break;

              case 'delete':
                _deleteFile(context);
                break;
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'rename', child: Text('Rename')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      );
    }

    return ExpansionTile(
      leading: const Icon(Icons.folder),
      title: Text(node.name),
      children: node.children
          .map(
            (child) => TreeNodeWidget(
              node: child,
              workspace: workspace,
              refresh: refresh,
            ),
          )
          .toList(),
    );
  }
}
