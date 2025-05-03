import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lextorah_chat_bot/admin/screens/upload.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:lextorah_chat_bot/src/routes.dart';

import 'package:lextorah_chat_bot/utils/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await initHive();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lextorah AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routerConfig: AppRouter.createRouter(),
    );
  }
}
