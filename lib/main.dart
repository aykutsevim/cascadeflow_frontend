import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cascade_flow/widgets/login_form.dart';

import 'core/web_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WebService.init();

  runApp(const ProviderScope(
    child: CascadeFlowApp(),
  ));
}

class CascadeFlowApp extends StatelessWidget {
  const CascadeFlowApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CascadeFlow',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 255, 255, 255),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      home: const LoginForm(),
    );
  }
}
