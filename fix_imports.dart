import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib dir not found');
    return;
  }

  // ignore: unused_local_variable
  int count = 0;
  for (var file in libDir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = file.readAsStringSync();
      String original = content;

      // Replace package imports
      content = content.replaceAll(RegExp(r'package:moeb_26/Services/'), 'package:moeb_26/services/');
      content = content.replaceAll(RegExp(r'package:moeb_26/Config/'), 'package:moeb_26/config/');
      content = content.replaceAll(RegExp(r'package:moeb_26/Repositories/'), 'package:moeb_26/repositories/');
      content = content.replaceAll(RegExp(r'package:moeb_26/Core/'), 'package:moeb_26/core/');

      // Replace relative imports like ../Services/, ../../Services/, etc.
      content = content.replaceAllMapped(RegExp(r'(\.\./)+Services/'), (match) => '${match.group(1)}services/');
      content = content.replaceAllMapped(RegExp(r'(\.\./)+Config/'), (match) => '${match.group(1)}config/');
      content = content.replaceAllMapped(RegExp(r'(\.\./)+Repositories/'), (match) => '${match.group(1)}repositories/');
      content = content.replaceAllMapped(RegExp(r'(\.\./)+Core/'), (match) => '${match.group(1)}core/');

      // Replace relative imports for same directory: ./Services/ (though rare)
      content = content.replaceAll(RegExp(r'\./Services/'), './services/');
      content = content.replaceAll(RegExp(r'\./Config/'), './config/');
      content = content.replaceAll(RegExp(r'\./Repositories/'), './repositories/');
      content = content.replaceAll(RegExp(r'\./Core/'), './core/');
      
      // Also catch imports like import 'Services/xyz.dart' without ./
      content = content.replaceAllMapped(RegExp(r"import\s+['""]Services/"), (match) => match.group(0)!.replaceAll('Services/', 'services/'));
      content = content.replaceAllMapped(RegExp(r"import\s+['""]Config/"), (match) => match.group(0)!.replaceAll('Config/', 'config/'));
      content = content.replaceAllMapped(RegExp(r"import\s+['""]Repositories/"), (match) => match.group(0)!.replaceAll('Repositories/', 'repositories/'));
      content = content.replaceAllMapped(RegExp(r"import\s+['""]Core/"), (match) => match.group(0)!.replaceAll('Core/', 'core/'));

      if (content != original) {
        file.writeAsStringSync(content);
        count++;
        print('Updated \${file.path}');
      }
    }
  }
  print('Updated \$count files.');
}
