import 'dart:io';
import 'package:rkmaul_cli/src/utils/helper.dart';

void createDomain(String name) {
  final packageName = 'domain_$name';
  final path = 'packages/domain/$packageName';

  print('🚀 Creating domain: $packageName');
  createPackage(path);

  Directory('$path/lib/src/entity').createSync(recursive: true);
  Directory('$path/lib/src/repository').createSync(recursive: true);
  Directory('$path/lib/src/usecase').createSync(recursive: true);

  File('$path/lib/$packageName.dart')
    ..createSync()
    ..writeAsStringSync('''
library $packageName;

export 'src/entity/entity.dart';
export 'src/repository/repository.dart';
export 'src/usecase/usecase.dart';
''');

  print('✅ Domain $packageName created at $path');
}
