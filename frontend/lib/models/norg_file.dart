class NorgFile {
  String filepath;
  String contents;

  bool modified;

  NorgFile({
    required this.filepath,
    required this.contents,
    this.modified = false,
  });

  factory NorgFile.fromJson(Map<String, dynamic> json) {
    return NorgFile(
      filepath: json['filepath'],
      contents: json['contents'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filepath': filepath,
      'contents': contents,
    };
  }
}
