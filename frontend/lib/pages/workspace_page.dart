import 'package:flutter/material.dart';

import '../models/norg_file.dart';
import '../models/workspace.dart';

import '../services/workspace_service.dart';

import '../utils/tree_builder.dart';

import '../widgets/tree_node_widget.dart';

class WorkspacePage extends StatefulWidget {
  final Workspace workspace;

  const WorkspacePage({super.key, required this.workspace});

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  final _service = WorkspaceService();

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _loadFiles();
  }

  Future<void> _loadFiles() async {
    widget.workspace.files = await _service.getFiles(widget.workspace.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveWorkspace() async {
    final success = await _service.syncWorkspace(widget.workspace);

    if (!mounted) {
      return;
    }

    if (success) {
      widget.workspace.modified = false;

      for (final file in widget.workspace.files) {
        file.modified = false;
      }

      setState(() {});
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Workspace saved.' : 'Failed to save workspace.',
        ),
      ),
    );
  }

  Future<void> _createFile() async {
    final controller = TextEditingController();

    final filepath = await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('New File'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'File path',
              hintText: 'notes/index.norg',
            ),
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
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (filepath == null || filepath.isEmpty) {
      return;
    }

    setState(() {
      widget.workspace.files.add(
        NorgFile(filepath: filepath, contents: '', modified: true),
      );

      widget.workspace.modified = true;
    });
  }

  Future<bool> _confirmLeave() async {
    if (!widget.workspace.modified) {
      return true;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Unsaved changes'),
          content: const Text(
            'You have unsaved changes. If you leave now, your changes will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final roots = TreeBuilder.build(widget.workspace.files);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final leave = await _confirmLeave();

        if (leave) {
          widget.workspace.modified = false;
        }

        if (!mounted || !leave) {
          return;
        }

        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.workspace.modified
                ? '${widget.workspace.name} *'
                : widget.workspace.name,
          ),
          actions: [
            IconButton(onPressed: _createFile, icon: const Icon(Icons.add)),
            IconButton(onPressed: _saveWorkspace, icon: const Icon(Icons.save)),
          ],
        ),
        body: ListView(
          children: roots
              .map(
                (node) => TreeNodeWidget(
                  node: node,
                  workspace: widget.workspace,
                  refresh: () {
                    setState(() {});
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
