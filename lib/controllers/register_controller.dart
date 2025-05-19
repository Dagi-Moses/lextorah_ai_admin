import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';

class RegisterController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void register(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    final auth = ref.watch(authProvider);

    if (auth.authLoading) return;

    if (formKey.currentState!.validate()) {
      authNotifier.register(
        email: emailController.text,

        password: passwordController.text,

        context: context,
      );
    }
  }

  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
  }
}
