import 'dart:io';

void createBackendFeature(String name) {
  final featureName = name.toLowerCase();
  final className = _capitalize(featureName);
  final basePath = '$featureName';

  final directories = [
    '$basePath/data/datasources',
    '$basePath/data/models',
    '$basePath/data/repositories',
    '$basePath/domain/entities',
    '$basePath/domain/repositories',
    '$basePath/domain/usecases',
    '$basePath/presentation/endpoints',
  ];

  for (final dir in directories) {
    Directory(dir).createSync(recursive: true);
  }

  /** ---------- DATA ---------- **/

  // datasource
  File('$basePath/data/datasources/${featureName}_datasource.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
abstract class ${className}DataSource {
  Future<String> getData();
}

class ${className}DataSourceImpl implements ${className}DataSource {
  @override
  Future<String> getData() async {
    // TODO: implement API or DB call
    return 'Data from ${className}DataSource';
  }
}
''');

  // model
  File('$basePath/data/models/${featureName}_model.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
class ${className}Model {
  final int id;
  final String name;

  ${className}Model({required this.id, required this.name});

  factory ${className}Model.fromJson(Map<String, dynamic> json) {
    return ${className}Model(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
''');

  // repository impl
  File('$basePath/data/repositories/${featureName}_repository_impl.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
import '../../domain/repositories/${featureName}_repository.dart';
import '../datasources/${featureName}_datasource.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}DataSource dataSource;

  ${className}RepositoryImpl(this.dataSource);

  @override
  Future<String> fetchData() async {
    return await dataSource.getData();
  }
}
''');

  /** ---------- DOMAIN ---------- **/

  // entity
  File('$basePath/domain/entities/${featureName}_entity.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
class ${className}Entity {
  final int id;
  final String name;

  ${className}Entity({required this.id, required this.name});
}
''');

  // repository interface
  File('$basePath/domain/repositories/${featureName}_repository.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
abstract class ${className}Repository {
  Future<String> fetchData();
}
''');

  // usecase
  File('$basePath/domain/usecases/get_${featureName}.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
import '../repositories/${featureName}_repository.dart';

class Get${className} {
  final ${className}Repository repository;

  Get${className}(this.repository);

  Future<String> execute() async {
    return await repository.fetchData();
  }
}
''');

  /** ---------- PRESENTATION ---------- **/

  // endpoint
  File('$basePath/presentation/endpoints/${featureName}_endpoint.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import '../../domain/usecases/get_${featureName}.dart';
import '../../data/datasources/${featureName}_datasource.dart';
import '../../data/repositories/${featureName}_repository_impl.dart';

class ${className}Endpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    final dataSource = ${className}DataSourceImpl();
    final repository = ${className}RepositoryImpl(dataSource);
    final usecase = Get${className}(repository);
    final data = await usecase.execute();

    return 'Hello \$name — \$data from ${className}Endpoint!';
  }
}
''');

  print('✅ Backend feature "$featureName" created successfully!');
  print('📁 Path: $basePath');
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
