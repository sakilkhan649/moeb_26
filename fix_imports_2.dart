import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib dir not found');
    return;
  }

  int count = 0;
  for (var file in libDir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = file.readAsStringSync();
      String original = content;

      // Replace broken relative imports with absolute imports
      final RegExp regExp = RegExp(r"import\s+['""](\.\./)+(services|config|repositories|core)/([^'""]+)['""];");
      content = content.replaceAllMapped(regExp, (match) {
        return "import 'package:moeb_26/${match.group(2)}/${match.group(3)}';";
      });

      if (content != original) {
        file.writeAsStringSync(content);
        count++;
        print('Updated \${file.path}');
      }
    }
  }
  print('Updated \$count files.');
}
