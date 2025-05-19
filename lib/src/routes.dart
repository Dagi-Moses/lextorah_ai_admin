import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/admin/screens/upload.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';
import 'package:lextorah_chat_bot/screens/errorScreen.dart';
import 'package:lextorah_chat_bot/screens/home_screen.dart';
import 'package:lextorah_chat_bot/screens/login.dart';
import 'package:lextorah_chat_bot/screens/pin_code.dart';
import 'package:lextorah_chat_bot/screens/signup.dart';
import 'package:lextorah_chat_bot/screens/splash_screen.dart';
import 'package:lextorah_chat_bot/src/refresh_stream.dart';
import 'package:lextorah_chat_bot/student/screens/chat_bot.dart' show ChatBot;
import 'package:lextorah_chat_bot/utils/roles.dart';

abstract class AppRouteName {
  static const upload = 'upload';
  static const chatbot = 'chat-bot';
  static const chat = 'chat';
  static const splash = 'splash';
  static const errorScreen = 'error';
  static const login = 'login';
  static const register = 'register';
  static const student = 'student';
  static const otpVerification = 'verify-otp';
}

abstract class AppRoutePath {
  static const upload = '/upload';
  static const chatbot = '/chat-bot';
  static const chat = '/chat';
  static const splash = '/splash';
  static const errorScreen = '/error/:message';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const otpVerification = '/auth/verify-otp/:email';
  static const student = '/student';
}

const publicPaths = [
  AppRoutePath.login,
  AppRoutePath.register,
  AppRoutePath.otpVerification,
  //AppRoutePath.splash,
];

class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    final authState = ref.read(authProvider);
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: AppRoutePath.splash,

      redirect: (context, state) {
        final isAuth = authState.isAuthenticated;
        final UserRole? role = authState.user?.role;
        final location = state.uri.toString();

        // 🚫 If user is not authenticated and trying to access protected path
        if (!isAuth && !publicPaths.any((path) => location.startsWith(path))) {
          return AppRoutePath.login;
        }
        // If authenticated but at login, redirect to role dashboard
        if (isAuth && location == AppRoutePath.login) {
          if (role?.isAdmin ?? false) {
            return AppRoutePath.upload;
          } else {
            return AppRoutePath.chat;
          }
        }

        // Prevent student from accessing admin routes and vice versa
        if (isAuth &&
            (role?.isStudent ?? false) &&
            location == AppRoutePath.upload) {
          return AppRoutePath.chat;
        }

        // if (isAuth &&
        //     (role?.isAdmin ?? false) &&
        //     location == AppRoutePath.chatbot) {
        //   return AppRoutePath.upload;
        // }

        return null; // No redirection
      },

      refreshListenable: GoRouterRefreshStream(
        ref.watch(authProvider.notifier).authChanges,
      ), // Add stream to listen to auth changes
      errorBuilder:
          (context, state) =>
              ErrorScreen(message: state.error?.toString() ?? "Page not found"),

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
          path: AppRoutePath.chat,
          name: AppRouteName.chat,
          builder: (context, state) => ChatBot(),
        ),
        GoRoute(
          path: AppRoutePath.splash,
          name: AppRouteName.splash,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: AppRoutePath.login,
          name: AppRouteName.login,
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: AppRoutePath.register,
          name: AppRouteName.register,
          builder: (context, state) => SignupScreen(),
        ),
        GoRoute(
          path: 'verify-otp/:email',
          name: AppRouteName.otpVerification,
          builder: (context, state) {
            final email = state.pathParameters['email'];
            return PinCodeVerificationScreen(email: email);
          },
          routes: [],
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
