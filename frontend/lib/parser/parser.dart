import 'ast.dart';

class Parser {
  static DocumentNode parse(String source) {
    final lines = source.replaceAll('\r\n', '\n').split('\n');

    final nodes = <Node>[];

    int i = 0;

    while (i < lines.length) {
      final line = lines[i];

      if (line.trim().isEmpty) {
        i++;
        continue;
      }

      if (line.startsWith('*')) {
        int level = 0;

        while (level < line.length && line[level] == '*') {
          level++;
        }

        nodes.add(
          HeadingNode(level: level, text: line.substring(level).trim()),
        );

        i++;
        continue;
      }

      if (line.startsWith('- ')) {
        final items = <BulletListItemNode>[];

        while (i < lines.length && lines[i].startsWith('- ')) {
          items.add(BulletListItemNode(lines[i].substring(2).trim()));
          i++;
        }

        nodes.add(BulletListNode(items));

        continue;
      }

      if (line.startsWith('@code')) {
        final language = line.substring(5).trim();

        i++;

        final buffer = StringBuffer();

        while (i < lines.length && !lines[i].startsWith('@end')) {
          buffer.writeln(lines[i]);

          i++;
        }

        nodes.add(CodeBlockNode(language: language, code: buffer.toString()));

        i++;

        continue;
      }

      final paragraph = StringBuffer();

      while (i < lines.length &&
          lines[i].trim().isNotEmpty &&
          !lines[i].startsWith('*') &&
          !lines[i].startsWith('- ') &&
          !lines[i].startsWith('@code')) {
        paragraph.writeln(lines[i]);

        i++;
      }

      nodes.add(ParagraphNode(paragraph.toString().trim()));
    }

    return DocumentNode(nodes);
  }
}
