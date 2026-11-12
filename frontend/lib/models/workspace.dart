import 'norg_file.dart';

class Workspace {
  final int id;
  final String name;

  List<NorgFile> files;

  bool modified;

  Workspace({
    required this.id,
    required this.name,
    this.files = const [],
    this.modified = false,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(id: json['id'], name: json['name']);
  }
}
