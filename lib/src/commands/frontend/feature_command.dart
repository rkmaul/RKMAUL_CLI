import 'dart:io';
import 'package:rkmaul_cli/src/utils/helper.dart';

void createFeature(String name) {
  final packageName = 'feature_$name';
  final path = 'packages/presentation/$packageName';
  final className = toPascalCase(name);

  print('🚀 Creating feature: $packageName');
  createPackage(path);

  Directory('$path/lib/src/bloc').createSync(recursive: true);
  Directory('$path/lib/src/page').createSync(recursive: true);
  Directory('$path/lib/src/widget').createSync(recursive: true);
  Directory('$path/lib/src/route').createSync(recursive: true);
  Directory('$path/lib/src/config').createSync(recursive: true);
  Directory('$path/lib/src/di').createSync(recursive: true);

  File('$path/lib/src/page/${packageName}_page.dart').createSync();

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

  File('$path/lib/src/config/${packageName}_router.dart')
    ..createSync()
    ..writeAsStringSync('''
import 'package:feature_common/feature_common.dart';
import 'package:$packageName/src/config/${packageName}_router.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'Page,Route')
class Feature${className}Router extends \$Feature${className}Router {}
''');

  File('$path/lib/src/config/config.dart')
    ..createSync()
    ..writeAsStringSync('''
export '${packageName}_config.dart';
export '${packageName}_router.dart';
export '${packageName}_router.gm.dart';
''');

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

  updatePubspec(path, '../../presentation/feature_common');

  print('✅ Feature $packageName created at $path');
}
