import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/admin/screens/upload.dart';
import 'package:lextorah_chat_bot/shared_components/errorScreen.dart';
import 'package:lextorah_chat_bot/shared_components/home_screen.dart';
import 'package:lextorah_chat_bot/shared_components/splash_screen.dart';
import 'package:lextorah_chat_bot/student/screens/chat_bot.dart' show ChatBot;

abstract class AppRouteName {
  static const upload = 'upload';
  static const chatbot = 'chat-bot';
  static const splash = 'splash';
  static const errorScreen = 'error';
}

abstract class AppRoutePath {
  static const upload = '/upload';
  static const chatbot = '/chat-bot';
  static const splash = '/splash';
  static const errorScreen = '/error/:message';
}

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutePath.chatbot,

      errorBuilder:
          (context, state) => const ErrorScreen(message: "Page not found"),

      routes: [
        // Shell Route for Persistent Admin Home
        ShellRoute(
          builder:
              (context, state, child) =>
                  HomeScreen(child: child), // Pass child to AdminHome
          routes: [
            GoRoute(
              path: AppRoutePath.chatbot,
              name: AppRouteName.chatbot,
              builder: (context, state) => const ChatBot(),
            ),

            GoRoute(
              path: AppRoutePath.upload,
              name: AppRouteName.upload,
              builder: (context, state) => const AdminPanel(),
            ),
          ],
        ),

        GoRoute(
          path: AppRoutePath.splash,
          name: AppRouteName.splash,
          builder: (context, state) => SplashScreen(),
        ),

        GoRoute(
          path: AppRoutePath.errorScreen,
          name: AppRouteName.errorScreen,
          builder: (context, state) {
            final message = state.pathParameters["message"]!;
            return ErrorScreen(message: message);
          },
        ),
      ],
    );
  }
}
