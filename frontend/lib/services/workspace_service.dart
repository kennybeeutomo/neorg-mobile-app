import 'dart:convert';

import '../models/norg_file.dart';
import '../models/workspace.dart';
import 'api_service.dart';

class WorkspaceService {
  final api = ApiService.instance;

  Future<List<Workspace>> getWorkspaces() async {
    final response = await api.get('/workspaces');

    final List json = jsonDecode(response.body);

    return json.map((e) => Workspace.fromJson(e)).toList();
  }

  Future<bool> createWorkspace(String name) async {
    final response = await api.post('/workspaces', {'name': name});

    return response.statusCode == 201;
  }

  Future<bool> renameWorkspace(int id, String name) async {
    final response = await api.put('/workspaces/$id', {'name': name});

    return response.statusCode == 200;
  }

  Future<bool> deleteWorkspace(int id) async {
    final response = await api.delete('/workspaces/$id');

    return response.statusCode == 200;
  }

  Future<List<NorgFile>> getFiles(int workspaceId) async {
    final response = await api.get('/workspaces/$workspaceId/files');

    final json = jsonDecode(response.body);

    return (json['files'] as List).map((e) => NorgFile.fromJson(e)).toList();
  }

  Future<bool> syncWorkspace(Workspace workspace) async {
    final response = await api.put('/workspaces/${workspace.id}/files', {
      "files": workspace.files.map((e) => e.toJson()).toList(),
    });

    return response.statusCode == 200;
  }
}
