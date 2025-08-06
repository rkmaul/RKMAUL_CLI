import 'dart:io';

import 'package:args/command_runner.dart';

class GenerateCommand extends Command {
  @override
  final name = 'generate';
  @override
  final description = 'Generate feature files with boilerplate';

  GenerateCommand();

  @override
  void run() {
    final featureName = argResults?.rest.firstOrNull;
    if (featureName == null) {
      print('Please provide a feature name, e.g. `rkmaul_cli generate auth`');
      return;
    }

    final basePath = 'packages/presentation/feature_$featureName/lib/src/config';

    final configDir = Directory(basePath)..createSync(recursive: true);

    final configFile = File('$basePath/feature_${featureName}_config.dart');
    final routeFile = File('$basePath/feature_${featureName}_route.dart');
    final routeGmFile = File('$basePath/feature_${featureName}_route.gm.dart');
    final exportFile = File('$basePath/../config.dart');

    configFile.writeAsStringSync('''
import 'package:feature_common/feature_common.dart';
import '../di/di.dart' as di;

class Feature${_capitalize(featureName)}Config extends ConfigPackage {
  Feature${_capitalize(featureName)}Config._();

  factory Feature${_capitalize(featureName)}Config.getInstance() {
    return _instance;
  }

  static final Feature${_capitalize(featureName)}Config _instance = Feature${_capitalize(featureName)}Config._();

  @override
  Future<bool> config({
    required Environment environment,
  }) async {
    await di.configureInjection(environment: environment);
    return Future.value(true);
  }
}
''');

    routeFile.writeAsStringSync('''
import 'package:feature_common/feature_common.dart';
import 'package:feature_$featureName/src/config/feature_${featureName}_route.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'Page,Route')
class Feature${_capitalize(featureName)}Router extends \$Feature${_capitalize(featureName)}Router {}
''');

    routeGmFile.writeAsStringSync('// Generated route config for $featureName');

    exportFile.writeAsStringSync('''
export 'config/feature_${featureName}_config.dart';
export 'config/feature_${featureName}_route.dart';
export 'config/feature_${featureName}_route.gm.dart';
''');

    print('✅ Feature "$featureName" generated at $basePath');
  }

  String _capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
}
