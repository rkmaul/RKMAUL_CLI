import 'dart:io';
import 'package:args/args.dart';

// FRONTEND COMMANDS
import 'package:rkmaul_cli/src/commands/frontend/data_command.dart';
import 'package:rkmaul_cli/src/commands/frontend/domain_command.dart';
import 'package:rkmaul_cli/src/commands/frontend/feature_command.dart';

// BACKEND COMMANDS
import 'package:rkmaul_cli/src/commands/backend/backend_feature_command.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  /** ───────────────────────────────────────────────
   * 💻 FRONTEND COMMANDS
   * Used for Flutter frontend project structure
   * ───────────────────────────────────────────────
   */
  parser
    ..addCommand('create-feature')
    ..addCommand('create-domain')
    ..addCommand('create-data');

  /** ───────────────────────────────────────────────
   * ⚙️ BACKEND COMMANDS
   * Used for Serverpod backend project structure
   * ───────────────────────────────────────────────
   */
  parser
    ..addCommand('create-backend-feature');

  // Parse arguments
  final ArgResults argResults = parser.parse(arguments);
  final command = argResults.command?.name;
  final name = argResults.command?.arguments.firstOrNull;

  // Validate input
  if (name == null) {
    print('❌ Please provide a name.\n');
    _printUsage();
    exit(1);
  }

  // Execute selected command
  switch (command) {
    /** ─────────── FRONTEND ─────────── */
    case 'create-feature':
      createFeature(name);
      break;
    case 'create-domain':
      createDomain(name);
      break;
    case 'create-data':
      createData(name);
      break;

    /** ─────────── BACKEND ─────────── */
    case 'create-backend-feature':
      createBackendFeature(name);
      break;

    /** ─────────── DEFAULT ─────────── */
    default:
      _printUsage();
  }
}

/** 📜 Displays command usage info */
void _printUsage() {
  print('''
📦 rkmaul CLI — Command List

💻 FRONTEND COMMANDS (Flutter App)
  rk create-feature <feature_name>     → Generate a complete feature folder structure
  rk create-domain <domain_name>       → Generate a domain layer structure
  rk create-data <data_name>           → Generate a data layer structure

🖥️ BACKEND COMMANDS (Serverpod Backend)
  rk create-backend-feature <name>     → Generate a backend feature structure for Serverpod

Examples:
  rk create-feature auth
  rk create-backend-feature user
''');
}
