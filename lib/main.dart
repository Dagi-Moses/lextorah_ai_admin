import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';
import 'package:lextorah_chat_bot/providers/shared_pref.dart';
import 'package:lextorah_chat_bot/screens/splash_screen.dart';
import 'package:lextorah_chat_bot/src/routes.dart';

import 'package:lextorah_chat_bot/utils/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  final Future<void> _init = _initializeApp();
  static Future<void> _initializeApp() async {
    await initHive();

    final prefs = await SharedPreferences.getInstance();
    _globalOverrides = [sharedPrefsProvider.overrideWithValue(prefs)];

    final container = ProviderContainer(overrides: _globalOverrides);

    await container.read(authProvider.notifier).tryAutoLogin();

    // Dispose the container after use
    container.dispose();
  }

  static late List<Override> _globalOverrides;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(), // your splash/loading widget
          );
        }

        return ProviderScope(
          overrides: _globalOverrides,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.createRouter(ref),
          ),
        );
      },
    );
  }
}

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp.router(
//       title: 'Lextorah AI',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.green,
//           surface: Colors.white,
//         ),
//       ),
//       routerConfig: AppRouter.createRouter(ref),
//     );
//   }
// }
