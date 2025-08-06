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

    final baseFeaturePath = 'packages/presentation/feature_$featureName/lib';
    final configPath = '$baseFeaturePath/src/config';
    final diPath = '$baseFeaturePath/src/di';

    // Create directories
    Directory(configPath).createSync(recursive: true);
    Directory(diPath).createSync(recursive: true);

    // Create config files
    final configFile = File('$configPath/feature_${featureName}_config.dart');
    final routeFile = File('$configPath/feature_${featureName}_route.dart');
    final routeGmFile = File('$configPath/feature_${featureName}_route.gm.dart');
    final exportFile = File('$baseFeaturePath/config.dart');

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

    // Create di.dart file
    final diFile = File('$diPath/di.dart');
    diFile.writeAsStringSync('''
import 'package:feature_common/feature_common.dart';

import '../di/di.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection({
  Environment environment = environmentDevelopment,
}) async =>
    getIt.init(environment: environment.name);
''');

    print('✅ Feature "$featureName" generated at $baseFeaturePath');
  }

  String _capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
}
