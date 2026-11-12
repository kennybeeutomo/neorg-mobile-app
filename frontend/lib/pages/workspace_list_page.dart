import 'package:flutter/material.dart';

import '../models/workspace.dart';

import '../services/auth_service.dart';
import '../services/workspace_service.dart';

import 'login_page.dart';
import 'workspace_page.dart';

class WorkspaceListPage extends StatefulWidget {
  const WorkspaceListPage({super.key});

  @override
  State<WorkspaceListPage> createState() => _WorkspaceListPageState();
}

class _WorkspaceListPageState extends State<WorkspaceListPage> {
  final _workspaceService = WorkspaceService();
  final _authService = AuthService();

  late Future<List<Workspace>> _future;

  @override
  void initState() {
    super.initState();

    _reload();
  }

  void _reload() {
    setState(() {
      _future = _workspaceService.getWorkspaces();
    });
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _createWorkspace() async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Create Workspace'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Workspace name'),
            autofocus: true,
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

    if (name == null || name.isEmpty) {
      return;
    }

    await _workspaceService.createWorkspace(name);

    _reload();
  }

  Future<void> _renameWorkspace(Workspace workspace) async {
    final controller = TextEditingController(text: workspace.name);

    final name = await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Rename Workspace'),
          content: TextField(controller: controller, autofocus: true),
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

    if (name == null || name.isEmpty) {
      return;
    }

    await _workspaceService.renameWorkspace(workspace.id, name);

    _reload();
  }

  Future<void> _deleteWorkspace(Workspace workspace) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Workspace'),
          content: Text('Delete "${workspace.name}"?'),
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

    await _workspaceService.deleteWorkspace(workspace.id);

    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspaces'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkspace,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Workspace>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load'));
          }

          final workspaces = snapshot.data ?? [];

          if (workspaces.isEmpty) {
            return const Center(child: Text('No workspaces'));
          }

          return ListView.builder(
            itemCount: workspaces.length,
            itemBuilder: (context, index) {
              final workspace = workspaces[index];

              return ListTile(
                leading: const Icon(Icons.folder),
                title: Text(workspace.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkspacePage(workspace: workspace),
                    ),
                  );
                },
                trailing: PopupMenuButton(
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'rename', child: Text('Rename')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'rename':
                        _renameWorkspace(workspace);
                        break;

                      case 'delete':
                        _deleteWorkspace(workspace);
                        break;
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
