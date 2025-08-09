import 'dart:io';

void createPackage(String path) {
  Process.runSync('flutter', ['create', '--template=package', path]);
}

void updatePubspec(String path, String featureCommonPath) {
  final pubspecPath = '$path/pubspec.yaml';
  final pubspecFile = File(pubspecPath);

  if (pubspecFile.existsSync()) {
    final lines = pubspecFile.readAsLinesSync();
    final updatedLines = <String>[];
    bool insideFlutterBlock = false;
    bool featureCommonAdded = false;

    for (final line in lines) {
      updatedLines.add(line);
      if (line.trim() == 'flutter:') {
        insideFlutterBlock = true;
      } else if (insideFlutterBlock && line.trim().startsWith('sdk:')) {
        updatedLines.add('  feature_common:');
        updatedLines.add('    path: $featureCommonPath');
        featureCommonAdded = true;
        insideFlutterBlock = false;
      }
    }
    if (!featureCommonAdded) {
      updatedLines.add('feature_common:');
      updatedLines.add('  path: $featureCommonPath');
    }
    pubspecFile.writeAsStringSync(updatedLines.join('\n'));
  }
}

String toPascalCase(String text) {
  return text
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join();
}
