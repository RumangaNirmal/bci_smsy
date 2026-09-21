import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'screens/home_shell.dart';
import 'state/bci_store.dart';

void main() {
  runApp(const BciManagementApp());
}

class BciManagementApp extends StatefulWidget {
  const BciManagementApp({super.key});

  @override
  State<BciManagementApp> createState() => _BciManagementAppState();
}

class _BciManagementAppState extends State<BciManagementApp> {
  final BciStore _store = BciStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      home: HomeShell(store: _store),
    );
  }
}
