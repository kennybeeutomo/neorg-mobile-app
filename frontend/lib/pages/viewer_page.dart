import 'package:flutter/material.dart';

import '../models/norg_file.dart';

import '../parser/parser.dart';
import '../parser/renderer.dart';

class ViewerPage extends StatelessWidget {
  final NorgFile file;

  const ViewerPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final document = Parser.parse(file.contents);

    return Scaffold(
      appBar: AppBar(title: Text(file.filepath)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Renderer.render(document),
      ),
    );
  }
}
