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

    final pascalName = _capitalize(featureName);

    // --- CONFIG FILES ---
//     File('$configPath/feature_${featureName}_config.dart').writeAsStringSync('''
// import 'package:feature_common/feature_common.dart';
// import '../di/di.dart' as di;
//
// class Feature${pascalName}Config extends ConfigPackage {
//   Feature${pascalName}Config._();
//
//   factory Feature${pascalName}Config.getInstance() {
//     return _instance;
//   }
//
//   static final Feature${pascalName}Config _instance = Feature${pascalName}Config._();
//
//   @override
//   Future<bool> config({
//     required Environment environment,
//   }) async {
//     await di.configureInjection(environment: environment);
//     return Future.value(true);
//   }
// }
// ''');
//
//     File('$configPath/feature_${featureName}_route.dart').writeAsStringSync('''
// import 'package:feature_common/feature_common.dart';
// import 'package:feature_$featureName/src/config/feature_${featureName}_route.gm.dart';
//
// @AutoRouterConfig.module(replaceInRouteName: 'Page,Route')
// class Feature${pascalName}Router extends \$Feature${pascalName}Router {}
// ''');
//
//     File('$configPath/feature_${featureName}_route.gm.dart').writeAsStringSync('// Generated route config for $featureName');
//
//     File('$baseFeaturePath/config.dart').writeAsStringSync('''
// export 'src/config/feature_${featureName}_config.dart';
// export 'src/config/feature_${featureName}_route.dart';
// export 'src/config/feature_${featureName}_route.gm.dart';
// ''');

    // --- DI FILE ---
    File('$diPath/di.dart').writeAsStringSync('''
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
