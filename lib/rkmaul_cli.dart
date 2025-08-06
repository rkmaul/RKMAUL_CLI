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
  final className = _toPascalCase(name);

  print('🚀 Creating feature: $packageName');

  // 1. Buat package
  Process.runSync('flutter', ['create', '--template=package', path]);

  // 2. Buat folder struktur
  Directory('$path/lib/src/bloc').createSync(recursive: true);
  Directory('$path/lib/src/page').createSync(recursive: true);
  Directory('$path/lib/src/widget').createSync(recursive: true);
  Directory('$path/lib/src/route').createSync(recursive: true);
  Directory('$path/lib/src/config').createSync(recursive: true);
  Directory('$path/lib/src/di').createSync(recursive: true);

  // 3. Generate file kosong
  File('$path/lib/src/bloc/bloc.dart').createSync();
  File('$path/lib/src/page/page.dart').createSync();
  File('$path/lib/src/widget/widget.dart').createSync();
  File('$path/lib/src/route/route.dart').createSync();

  // 4. Generate config files
  File('$path/lib/src/config/${packageName}_config.dart')
    ..createSync()
    ..writeAsStringSync('''
import 'package:feature_common/feature_common.dart';
import '../di/di.dart' as di;

class Feature${className}Config extends ConfigPackage {
  Feature${className}Config._();

  factory Feature${className}Config.getInstance() {
    return _instance;
  }

  static final Feature${className}Config _instance = Feature${className}Config._();

  @override
  Future<bool> config({
    required Environment environment,
  }) async {
    await di.configureInjection(environment: environment);
    return Future.value(true);
  }
}
''');

  File('$path/lib/src/config/${packageName}_route.dart')
    ..createSync()
    ..writeAsStringSync('''
import 'package:feature_common/feature_common.dart';
import 'package:$packageName/src/config/${packageName}_route.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'Page,Route')
class ${className}Router extends \$${className}Router {}
''');

  File('$path/lib/src/config/config.dart')
    ..createSync()
    ..writeAsStringSync('''
export '${packageName}_config.dart';
export '${packageName}_route.dart';
export '${packageName}_route.gm.dart';
''');

  // 5. Generate library export
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

  // --- DI FILE ---
  File('$path/lib/src/di/di.dart').writeAsStringSync('''
import 'package:feature_common/feature_common.dart';

import '../di/di.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection({
  Environment environment = environmentDevelopment,
}) async =>
    getIt.init(environment: environment.name);
''');

  final pubspecPath = '$path/pubspec.yaml';
  final pubspecFile = File(pubspecPath);

  if (pubspecFile.existsSync()) {
    final lines = pubspecFile.readAsLinesSync();

    final updatedLines = <String>[];
    bool insideFlutterBlock = false;
    bool featureCommonAdded = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      updatedLines.add(line);

      if (line.trim() == 'flutter:') {
        insideFlutterBlock = true;
      } else if (insideFlutterBlock && line.trim().startsWith('sdk:')) {
        // Add feature_common after sdk: flutter
        updatedLines.add('  feature_common:');
        updatedLines.add('    path: ../../presentation/feature_common');
        featureCommonAdded = true;
        insideFlutterBlock = false; // prevent multiple inserts
      }
    }

    // Backup if somehow not added
    if (!featureCommonAdded) {
      updatedLines.add('feature_common:');
      updatedLines.add('  path: ../../presentation/feature_common');
    }

    pubspecFile.writeAsStringSync(updatedLines.join('\n'));
  }


  print('✅ Feature $packageName created at $path');
}

String _toPascalCase(String text) {
  return text
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join();
}

