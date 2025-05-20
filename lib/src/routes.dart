import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/admin/components/side_bar.dart';
import 'package:lextorah_chat_bot/admin/screens/upload.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';
import 'package:lextorah_chat_bot/screens/errorScreen.dart';
import 'package:lextorah_chat_bot/screens/home_screen.dart';
import 'package:lextorah_chat_bot/screens/login.dart';
import 'package:lextorah_chat_bot/screens/pin_code.dart';
import 'package:lextorah_chat_bot/screens/signup.dart';
import 'package:lextorah_chat_bot/screens/splash_screen.dart';
import 'package:lextorah_chat_bot/student/components/student_menu.dart';
import 'package:lextorah_chat_bot/student/screens/chat_bot.dart' show ChatBot;
import 'package:lextorah_chat_bot/utils/roles.dart';

abstract class AppRouteName {
  static const upload = 'upload';
  static const chat = 'chat';
  static const splash = 'splash';
  static const errorScreen = 'error';
  static const login = 'login';
  static const register = 'register';
  static const otpVerification = 'verify-otp';
}

abstract class AppRoutePath {
  static const upload = '/admin/upload';
  static const chat = '/chat';
  static const splash = '/splash';
  static const errorScreen = '/error/:message';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const otpVerification = '/auth/verify-otp/:email';
  static const otpBasePath = '/auth/verify-otp';
}

const publicPaths = [
  AppRoutePath.login,
  AppRoutePath.register,
  AppRoutePath.otpBasePath,
  // AppRoutePath.splash,
];

class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    final isAuth = ref.watch(
      authProvider.select((state) => state.isAuthenticated),
    );
    final role = ref.watch(authProvider.select((state) => state.user?.role));

    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation:
          !isAuth
              ? AppRoutePath.splash
              : (role?.isAdmin ?? false)
              ? AppRoutePath.upload
              : AppRoutePath.chat,
      redirect: (context, state) {
        final location = state.uri.toString();

        final isPublic = publicPaths.any((path) => location.startsWith(path));

        if (!isAuth && !isPublic) {
          return AppRoutePath.login;
        }

        if (isAuth &&
            role?.isStudent == true &&
            location.startsWith('/admin')) {
          return AppRoutePath.chat;
        }

        if (isAuth && role?.isTrial == true && location.startsWith('/admin')) {
          return AppRoutePath.chat;
        }

        if (isAuth && location.startsWith('/auth')) {
          return (role?.isAdmin ?? false)
              ? AppRoutePath.upload
              : AppRoutePath.chat;
        }

        return null;
      },
      errorBuilder:
          (context, state) =>
              ErrorScreen(message: state.error?.toString() ?? "Page not found"),

      routes: [
        ShellRoute(
          builder: (context, state, child) {
            final Widget sideMenu =
                (role?.isAdmin ?? false) ? SideMenu() : StudentMenu();

            return HomeScreen(sideMenu: sideMenu, child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutePath.chat,
              name: AppRouteName.chat,
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
          path: '/auth/verify-otp/:email',
          name: AppRouteName.otpVerification,
          builder: (context, state) {
            final email = Uri.decodeComponent(
              state.pathParameters['email'] ?? '',
            );
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
