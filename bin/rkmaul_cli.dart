import 'dart:io';
import 'package:args/args.dart';
import 'package:rkmaul_cli/src/commands/data_command.dart';
import 'package:rkmaul_cli/src/commands/domain_command.dart';
import 'package:rkmaul_cli/src/commands/feature_command.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('create-feature')
    ..addCommand('create-domain')
    ..addCommand('create-data');

  final ArgResults argResults = parser.parse(arguments);
  final command = argResults.command?.name;
  final name = argResults.command?.arguments.firstOrNull;

  if (name == null) {
    print('❌ Please provide a name.');
    print('Usage:');
    print('  rk create-feature <feature_name>');
    print('  rk create-domain <domain_name>');
    print('  rk create-data <data_name>');
    exit(1);
  }

  switch (command) {
    case 'create-feature':
      createFeature(name);
      break;
    case 'create-domain':
      createDomain(name);
      break;
    case 'create-data':
      createData(name);
      break;
    default:
      print('Usage: rk <command> <name>');
  }
}
