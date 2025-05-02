import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lextorah_chat_bot/screens/home_screen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:lextorah_chat_bot/screens/splash_screen.dart';
import 'package:lextorah_chat_bot/utils/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const SplashScreen()); // Show this immediately
  await initHive();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lextorah AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const AdminPanel(),
    );
  }
}
