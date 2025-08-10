# 🛠️ rkmaul_cli

`rkmaul_cli` is a custom CLI tool for personal use, designed to help generate Flutter feature structures faster within a monorepo setup.

---

## 🚀 Features

- Generate feature folder templates for Flutter projects
- Intended for internal/personal use (no need to publish to pub.dev)

---

## 📁 Project Structure

```
rkmaul_cli/
├── bin/
│   └── rkmaul_cli.dart
├── lib/
├── pubspec.yaml
└── README.md
```

---

## 🧰 Setup Instructions

### 1. ✅ Ensure Dart SDK is installed

Check with:

```bash
dart --version
```

If not installed, download it from: https://dart.dev/get-dart

---

### 2. 📝 Update your `pubspec.yaml`

Make sure `pubspec.yaml` contains the proper `executables` config:

```yaml
name: rkmaul_cli
description: PERSONAL CLI, FOR CREATE A FLUTTER PACKAGE
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  args: ^2.0.0

executables:
  rkmaul_cli:
```

> 🚫 DO NOT add path like `bin/rkmaul_cli.dart` under `executables`.

---

### 3. 🐙 Install CLI from GitHub

Run the following command to activate globally from your repo:

```bash
dart pub global activate --source git https://github.com/rkmaul/rkmaul_cli.git
```

If you’re developing locally:

```bash
dart pub global activate --source path ./rkmaul_cli
```

---

### 4. 🛣️ Add Dart CLI bin to PATH

If not already set, run this once:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

Check if the CLI is globally available:

```bash
which rkmaul_cli
```

---

### 5. ⚡ Use the CLI

Example:

```bash
rkmaul_cli create-feature profile
```

---

## ✅ Tips

- After updating code in your CLI, re-run:

```bash
dart pub global deactivate rkmaul_cli
dart pub global activate --source path ./rkmaul_cli
```

---

Happy coding! 🚀
