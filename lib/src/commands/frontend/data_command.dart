import 'dart:io';
import 'package:rkmaul_cli/src/utils/helper.dart';

void createData(String name) {
  final packageName = 'data_$name';
  final path = 'packages/data/$packageName';

  print('🚀 Creating data: $packageName');
  createPackage(path);

  Directory('$path/lib/src/datasource').createSync(recursive: true);
  Directory('$path/lib/src/model').createSync(recursive: true);
  Directory('$path/lib/src/repository_impl').createSync(recursive: true);

  File('$path/lib/$packageName.dart')
    ..createSync()
    ..writeAsStringSync('''
library $packageName;

export 'src/datasource/datasource.dart';
export 'src/model/model.dart';
export 'src/repository_impl/repository_impl.dart';
''');

  print('✅ Data $packageName created at $path');
}
