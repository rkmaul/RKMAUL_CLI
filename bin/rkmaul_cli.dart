import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
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

  Process.runSync('flutter', ['create', '--template=package', path]);
  Directory('$path/lib/src/bloc').createSync(recursive: true);
  Directory('$path/lib/src/page').createSync(recursive: true);
  Directory('$path/lib/src/widget').createSync(recursive: true);
  Directory('$path/lib/src/route').createSync(recursive: true);
  Directory('$path/lib/src/config').createSync(recursive: true);
  Directory('$path/lib/src/di').createSync(recursive: true);

  File('$path/lib/src/bloc/bloc.dart').createSync(recursive: true);
  File('$path/lib/src/page/page.dart').createSync(recursive: true);
  File('$path/lib/src/widget/widget.dart').createSync(recursive: true);
  File('$path/lib/src/route/route.dart').createSync(recursive: true);
  File('$path/lib/src/config/config.dart').createSync(recursive: true);
  File('$path/lib/src/di/di.dart').createSync(recursive: true);

  File('$path/lib/$packageName.dart')
    ..createSync()
    ..writeAsStringSync('''
library $packageName;

export 'src/bloc/bloc.dart';
export 'src/page/page.dart';
export 'src/widget/widget.dart';
export 'src/route/route.dart';
export 'src/config/config.dart';
export 'src/di/di.dart';
''');

  print('✅ Feature $packageName created at $path');
}
