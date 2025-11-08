import 'dart:io';

void createBackendFeature(String name) {
  final featureName = name.toLowerCase();
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

  // Template file endpoint
  final endpointFile = File('$basePath/presentation/endpoints/${featureName}_endpoint.dart');
  endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ${_capitalize(featureName)}Endpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name from ${_capitalize(featureName)}Endpoint!';
  }
}
''');

  print('✅ Backend feature "$featureName" created successfully!');
  print('Path: $basePath');
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
