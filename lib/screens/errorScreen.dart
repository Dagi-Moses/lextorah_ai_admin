import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/src/routes.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, this.message = "Something went wrong!"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                } else if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go(AppRoutePath.login);
                }
              },
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
