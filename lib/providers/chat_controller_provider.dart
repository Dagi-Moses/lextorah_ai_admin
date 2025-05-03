import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lextorah_chat_bot/hive/chat_message.dart';
import 'package:lextorah_chat_bot/providers/chat_messages_provider.dart';
import 'package:lextorah_chat_bot/src/api_service.dart';

final chatControllerProvider = Provider((ref) {
  return ChatController(ref);
});

class ChatController {
  final Ref ref;

  ChatController(this.ref);

  Future<void> sendMessage(String text) async {
    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    try {
      final response = await http.post(
        Uri.parse(ApiService.ask),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': text}),
      );

      await chatNotifier.removeTypingIndicator();

      if (response.statusCode == 200) {
        final reply = jsonDecode(response.body)['answer'] ?? 'No response';

        final botMessage = ChatMessage(text: reply);

        await ref.read(chatMessagesProvider.notifier).addMessage(botMessage);
      } else {
        await ref
            .read(chatMessagesProvider.notifier)
            .addMessage(
              ChatMessage(
                text: 'Error: Something went wrong. Please try again later...',
                isError: true,
              ),
            );
      }
    } catch (e) {
      await chatNotifier.removeTypingIndicator();

      if (e is SocketException) {
        await ref
            .read(chatMessagesProvider.notifier)
            .addMessage(
              ChatMessage(
                text:
                    'Network error: Please check your connection and try again.',
                isError: true,
              ),
            );
      } else {
        await ref
            .read(chatMessagesProvider.notifier)
            .addMessage(
              ChatMessage(
                text: 'Error: Something went wrong. Please try again later.',
                isError: true,
              ),
            );
      }
    }
  }
}
