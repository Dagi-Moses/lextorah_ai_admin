import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:lextorah_chat_bot/hive/uploaded_file_hive_model.dart';
import 'package:lextorah_chat_bot/providers/chat_messages_provider.dart';
import 'package:lextorah_chat_bot/providers/shared_pref.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:lextorah_chat_bot/models/user.dart';
import 'package:lextorah_chat_bot/src/routes.dart';
import 'package:lextorah_chat_bot/utils/roles.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final bool authLoading;
  final String? errorMessage;
  final String currentText;

  AuthState({
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
    this.authLoading = false,
    this.errorMessage,
    this.currentText = "",
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? authLoading,
    String? errorMessage,
    User? user,
    String? currentText, // <-- Add to copyWith
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
      authLoading: authLoading ?? this.authLoading,
      currentText: currentText ?? this.currentText, // <-- Copy value
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState(isAuthenticated: false));

  // Getter for currentText
  String get currentText => state.currentText;

  // Setter for currentText
  set currentText(String value) {
    state = state.copyWith(currentText: value);
  }

  Future<void> persistUser({required User user}) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString('token', user.token);
    await prefs.setString('email', user.email);
    await prefs.setString('id', user.id);
    await prefs.setString('role', user.role.name);
    await prefs.setString('trialEndsAt', user.trialEndsAt.toIso8601String());
  }

  Future<void> freeTrialLogin({
    required String email,
    String? password,
    required BuildContext context,
    TextEditingController? resendController,
    bool isResend = false,
  }) async {
    state = state.copyWith(authLoading: true, errorMessage: null);
    // Retrieve data from SharedPreferences
    final prefs = ref.read(sharedPrefsProvider);
    String? pass;

    try {
      if (!isResend && password != null) {
        resendController?.clear();
        final passwor = prefs.getString('reg_password') ?? '';
        pass = passwor;
      }

      // Persist user data
      if (!isResend) {
        await prefs.setString('reg_password', password!);
      }
      final response = await http
          .post(
            Uri.parse('https://ai1-zjt4.onrender.com/api/freetrial/login'),
            body: jsonEncode({
              'email': email,
              'password': password?.trim() ?? pass?.trim(),
            }),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        state = state.copyWith(authLoading: false);
        final data = jsonDecode(response.body);
        final detail = data['detail'] ?? "OTP sent, please verify to continue";

        Fluttertoast.showToast(
          msg: detail,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        context.goNamed(
          AppRouteName.otpVerification,
          pathParameters: {'email': Uri.encodeComponent(email)},
        );
      } else {
        final data = jsonDecode(response.body);
        final error = data['detail'] ?? 'Login failed. Please try again.';

        state = state.copyWith(authLoading: false, errorMessage: error);
      }
    } on TimeoutException {
      const error = 'Connection timed out. Please check your network.';
      state = state.copyWith(authLoading: false, errorMessage: error);
    } on http.ClientException {
      const error = 'Network error occurred. Please try again.';
      state = state.copyWith(authLoading: false, errorMessage: error);
    } catch (e, stack) {
      debugPrintStack(label: 'Login error', stackTrace: stack);

      const error = 'Unexpected error occurred. Please try again.';
      state = state.copyWith(authLoading: false, errorMessage: error);
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    StreamController<ErrorAnimationType>? errorController,
    String? email,
  }) async {
    print("otp: " + currentText);
    print("email: " + email!);
    state = state.copyWith(authLoading: true, errorMessage: null);
    try {
      final response = await http
          .post(
            Uri.parse('https://ai1-zjt4.onrender.com/api/api/verify'),
            body: jsonEncode({
              'email': email.trim(),
              'otp': currentText.trim(),
            }),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 60));

      print("response" + response.body.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("response" + data.toString());
        final token = data['token'];
        final trial_ends_at = data['trial_ends_at'];
        final decoded = JwtDecoder.decode(token);
        final userRole = userRoleFromString(decoded['role']);
        state = AuthState(
          isAuthenticated: true,
          authLoading: false,
          user: User(
            id: decoded['sub'],
            email: decoded['email'],
            role: userRole,
            tokenExpiresAt: JwtDecoder.getExpirationDate(token),
            trialEndsAt: DateTime.parse(trial_ends_at),
            token: token,
          ),
        );
        print("userrrrrrrrrrr: " + userRole.toString());
        persistUser(
          user: User(
            id: decoded['sub'],
            email: decoded['email'],
            role: userRoleFromString(decoded['role']),
            tokenExpiresAt: JwtDecoder.getExpirationDate(token),
            trialEndsAt: DateTime.parse(trial_ends_at),
            token: token,
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          final router = GoRouter.of(context);
          if (userRole.isAdmin) {
            router.go(AppRoutePath.upload);
          } else {
            router.go(AppRoutePath.chat);
          }
        });
        Fluttertoast.showToast(
          msg: "success",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        final chatNotifier = ref.read(chatMessagesProvider.notifier);
        chatNotifier.deleteAllMessages();
      } else {
        final data = jsonDecode(response.body);
        final error = data['detail'] ?? 'Invalid OTP';
        errorController?.add(ErrorAnimationType.shake); // Tr
        state = state.copyWith(authLoading: false, errorMessage: error);
      }
    } on TimeoutException {
      const error = 'Connection timed out. Please check your network.';
      state = state.copyWith(authLoading: false, errorMessage: error);
    } on http.ClientException {
      const error = 'Network error occurred. Please try again.';
      state = state.copyWith(authLoading: false, errorMessage: error);
    } catch (e) {
      final error = e.toString();
      state = state.copyWith(authLoading: false, errorMessage: error);
      errorController?.add(ErrorAnimationType.shake);
      print(" error :" + e.toString());
      Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> standardLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = state.copyWith(authLoading: true, errorMessage: null);
    try {
      final response = await http
          .post(
            Uri.parse(
              'https://www.lextorah-elearning.com/ap/laravel/api/login',
            ),
            body: jsonEncode({
              'email': email.trim(),
              'password': password.trim(),
            }),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 60));

      print("Decoded login response: ${response.body}");
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final token = data['token'];
        final trial_ends_at = data['expires_in'];
        final decoded = JwtDecoder.decode(token);
        final userRole = userRoleFromString(decoded['role']);
        state = AuthState(
          isAuthenticated: true,
          user: User(
            id: decoded['sub'],
            email: decoded['email'],
            role: userRole,
            tokenExpiresAt: JwtDecoder.getExpirationDate(token),
            trialEndsAt: DateTime.parse(trial_ends_at),
            token: token,
          ),
        );
        print("userrole: " + userRoleFromString(decoded['role']).toString());
        persistUser(
          user: User(
            id: decoded['sub'],
            email: decoded['email'],
            role: userRole,
            tokenExpiresAt: JwtDecoder.getExpirationDate(token),
            trialEndsAt: DateTime.parse(trial_ends_at),
            token: token,
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          final router = GoRouter.of(context);
          if (userRole.isAdmin) {
            router.go(AppRoutePath.upload);
          } else {
            router.go(AppRoutePath.chat);
          }
        });
        Fluttertoast.showToast(
          msg: "success",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        final chatNotifier = ref.read(chatMessagesProvider.notifier);
        chatNotifier.deleteAllMessages();
      } else {
        final data = jsonDecode(response.body);
        final error = data['msg'] ?? "Login failed. Please try again.";

        state = state.copyWith(authLoading: false, errorMessage: error);
      }
    } on TimeoutException {
      const error = 'Connection timed out. Please check your network.';
      state = state.copyWith(authLoading: false, errorMessage: error);
    } on http.ClientException {
      const error = 'Network error occurred. Please try again.';
      state = state.copyWith(authLoading: false, errorMessage: error);
    } catch (e, stack) {
      debugPrintStack(label: 'Login error', stackTrace: stack);
      print("error" + e.toString());
      final error = e.toString();
      state = state.copyWith(authLoading: false, errorMessage: error);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = state.copyWith(authLoading: true, errorMessage: null);

    try {
      final response = await http
          .post(
            Uri.parse('https://ai1-zjt4.onrender.com/api/freetrial/register'),
            body: jsonEncode({'email': email, 'password': password}),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(authLoading: false);
        final data = jsonDecode(response.body);
        print(data.toString());

        Fluttertoast.showToast(
          msg: "Registration successful, please login to continue",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        await Future.delayed(const Duration(seconds: 2));

        context.go(AppRoutePath.login);
      } else {
        final data = jsonDecode(response.body);
        final error =
            data['detail'] ?? 'Registration failed. Please try again.';
        state = state.copyWith(authLoading: false, errorMessage: error);
      }
    } on TimeoutException {
      state = state.copyWith(
        authLoading: false,
        errorMessage: 'Connection timed out. Please check your network.',
      );
    } on http.ClientException {
      state = state.copyWith(
        authLoading: false,
        errorMessage: 'Network error occurred. Please try again.',
      );
    } catch (e, stack) {
      debugPrintStack(label: 'Registration error', stackTrace: stack);
      state = state.copyWith(
        authLoading: false,
        errorMessage: 'Unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> logout() async {
    // Clear auth state
    state = AuthState(isAuthenticated: false);

    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    chatNotifier.deleteAllMessages();
    final box = await Hive.openBox<UploadedFileHiveModel>('uploaded');
    box.clear();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || JwtDecoder.isExpired(token)) return;

    final email = prefs.getString('email');
    final id = prefs.getString('id');
    final role = userRoleFromString(prefs.getString('role') ?? '');
    final trialEndsAt = DateTime.parse(prefs.getString('trialEndsAt') ?? '');

    final user = User(
      id: id!,
      email: email!,
      role: role,
      token: token,
      tokenExpiresAt: JwtDecoder.getExpirationDate(token),
      trialEndsAt: trialEndsAt,
    );

    state = AuthState(isAuthenticated: true, user: user);
  }
}
