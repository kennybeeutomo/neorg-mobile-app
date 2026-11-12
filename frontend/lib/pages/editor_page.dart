import 'package:flutter/material.dart';

import '../models/norg_file.dart';

import 'viewer_page.dart';

class EditorPage extends StatefulWidget {
  final NorgFile file;
  final VoidCallback onModified;

  const EditorPage({super.key, required this.file, required this.onModified});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.text = widget.file.contents;

    _controller.addListener(_textChanged);
  }

  void _textChanged() {
    widget.file.contents = _controller.text;

    if (!widget.file.modified) {
      widget.file.modified = true;
      widget.onModified();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_textChanged);
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.filepath),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              widget.file.contents = _controller.text;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewerPage(file: widget.file),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox.expand(
          child: TextField(
            controller: _controller,
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(fontFamily: 'monospace'),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ),
    );
  }
}
