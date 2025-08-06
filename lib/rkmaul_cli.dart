import 'dart:io';
import 'package:args/args.dart';

void run(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('create-feature');

  final ArgResults argResults = parser.parse(arguments);

  if (argResults.command?.name == 'create-feature') {
    final featureName = argResults.command?.arguments.firstOrNull;

    if (featureName == null) {
      print('❌ Please provide a feature name.');
      print('Usage: rk create-feature <feature_name>');
      exit(1);
    }

    createFeature(featureName);
  } else {
    print('Usage: rk create-feature <feature_name>');
  }
}

void createFeature(String name) {
  final packageName = 'feature_$name';
  final path = 'packages/presentation/$packageName';

  print('🚀 Creating feature: $packageName');

  // Buat package Flutter baru
  Process.runSync('flutter', ['create', '--template=package', path]);

  // Buat subfolder SRC
  final subDirs = [
    'bloc',
    'page',
    'widget',
    'route',
    'config',
    'di',
  ];

  for (var dir in subDirs) {
    Directory('$path/lib/src/$dir').createSync(recursive: true);
    File('$path/lib/src/$dir/$dir.dart').createSync(recursive: true);
  }

  // Buat file utama untuk export semua
  File('$path/lib/$packageName.dart')
    ..createSync()
    ..writeAsStringSync('''
library $packageName;

${subDirs.map((d) => "export 'src/$d/$d.dart';").join('\n')}
''');

  print('✅ Feature $packageName created at $path');
}
