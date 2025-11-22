import 'dart:io';
import 'package:args/args.dart';

// FRONTEND COMMANDS
import 'package:rkmaul_cli/src/commands/frontend/data_command.dart';
import 'package:rkmaul_cli/src/commands/frontend/domain_command.dart';
import 'package:rkmaul_cli/src/commands/frontend/feature_command.dart';

// BACKEND COMMANDS
import 'package:rkmaul_cli/src/commands/backend/backend_feature_command.dart';

// NATIVE ENGINE (KMP)
import 'package:rkmaul_cli/src/commands/native/native_engine_command.dart';

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

  /** ───────────────────────────────────────────────
   * 🧠 NATIVE ENGINE (KMP)
   * Generate KMP module for Flutter data layer
   * ───────────────────────────────────────────────
   */
  parser
    ..addCommand('create-native-engine');

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

    /** ─────────── NATIVE ENGINE (KMP) ─────────── */
    case 'create-native-engine':
      createNativeEngine();
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

💻 FRONTEND (Flutter)
  rkmaul_cli create-feature <feature_name>       
  rkmaul_cli create-domain <domain_name>         
  rkmaul_cli create-data <data_name>             

🖥️ BACKEND (Serverpod)
  rkmaul_cli create-backend-feature <name>       

⚙️ NATIVE ENGINE (KMP - Kotlin Multiplatform)
  rkmaul_cli create-native-engine <engine_name>  
    → Generate KMP module for Flutter data layer replacement

📌 Examples:
  rkmaul_cli create-feature auth
  rkmaul_cli create-domain expenses
  rkmaul_cli create-data transaction
  rkmaul_cli create-backend-feature product
  rkmaul_cli create-native-engine finance
''');
}
