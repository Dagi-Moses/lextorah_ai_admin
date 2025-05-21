import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lextorah_chat_bot/providers/auth_provider.dart';

void showSessionExpiredDialog(BuildContext context, Ref ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Session Expired"),
        content: const Text(
          "Your session has expired. Please log in again to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            child: const Text("Login"),
          ),
        ],
      );
    },
  );
}
