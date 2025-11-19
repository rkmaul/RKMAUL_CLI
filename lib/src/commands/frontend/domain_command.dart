import 'dart:io';
import 'package:rkmaul_cli/src/utils/helper.dart';

void createDomain(String name) {
  final packageName = 'domain_$name';
  final path = 'packages/domain/$packageName';
  final className = toPascalCase(name);

  print('🚀 Creating domain: $packageName');
  createPackage(path);

  Directory('$path/lib/src/entity').createSync(recursive: true);
  Directory('$path/lib/src/repository').createSync(recursive: true);
  Directory('$path/lib/src/usecase').createSync(recursive: true);
  Directory('$path/lib/src/model').createSync(recursive: true);
  Directory('$path/lib/src/di').createSync(recursive: true);
  Directory('$path/lib/src/config').createSync(recursive: true);

  File('$path/lib/src/config/${packageName}_config.dart')
    ..createSync()
    ..writeAsStringSync('''
import 'package:domain_common/domain_common.dart';
import '../di/di.dart' as di;

class Domain${className}Config extends ConfigPackage {
  Domain${className}Config._();

  factory Domain${className}Config.getInstance() {
    return _instance;
  }

  static final Domain${className}Config _instance = Domain${className}Config._();

  @override
  Future<bool> config({
    required Environment environment,
  }) async {
    await di.configureInjection(environment: environment);
    return Future.value(true);
  }
}
''');

  File('$path/lib/src/config/config.dart')
    ..createSync()
    ..writeAsStringSync('''
export '${packageName}_config.dart';
''');

  File('$path/lib/src/di/di.dart')
    ..createSync()
    ..writeAsStringSync('''
import 'package:domain_common/domain_common.dart';
import '../di/di.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureInjection({
  Environment environment = environmentDevelopment,
}) async =>
    getIt.init(environment: environment.name);
''');

  File('$path/lib/$packageName.dart')
    ..createSync()
    ..writeAsStringSync('''
library $packageName;

export 'src/entity/entity.dart';
export 'src/repository/repository.dart';
export 'src/usecase/usecase.dart';
export 'src/model/model.dart';
export 'src/config/config.dart';
export 'src/di/di.dart';
''');

  print('✅ Domain $packageName created at $path');
}
