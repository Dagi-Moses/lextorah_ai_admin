import 'dart:convert';

import 'package:flutter/material.dart';
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
    final message = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    await ref.read(chatMessagesProvider.notifier).addMessage(message);
    try {
      print("trying..................");
      final response = await http.post(
        Uri.parse(ApiService.ask),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': text}),
      );
      print("reply: " + response.body);
      print("reply00000: " + response.toString());

      if (response.statusCode == 200) {
        final reply = jsonDecode(response.body)['answer'] ?? 'No response';
        print("reply: " + reply);
        final botMessage = ChatMessage(
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        );
        await ref.read(chatMessagesProvider.notifier).addMessage(botMessage);
      } else {
        await ref
            .read(chatMessagesProvider.notifier)
            .addMessage(
              ChatMessage(
                text: 'Error: ${response.statusCode}',
                isError: true,
                isUser: false,
                timestamp: DateTime.now(),
              ),
            );
      }
    } catch (e) {
      print("error: " + e.toString());
      await ref
          .read(chatMessagesProvider.notifier)
          .addMessage(
            ChatMessage(
              text: 'Network error: $e',
              isError: true,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
    }
  }
}

// ture<void> sendMessage(String text) async {
//     final userMessage = ChatMessage(
//       text: text,
//       isUser: true,
//       timestamp: DateTime.now(),
//     );
//     _messages.add(userMessage);
//     _box.add(userMessage);
//     notifyListeners();

//     try {
//       final response = await http.post(
//         Uri.parse(ApiService.ask),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'question': text}),
//       );

//       if (response.statusCode == 200) {
//         final botReply = jsonDecode(response.body)['answer'] ?? 'No response';
//         final botMessage = ChatMessage(
//           text: botReply,
//           isUser: false,
//           timestamp: DateTime.now(),
//         );
//         _messages.add(botMessage);
//         _box.add(botMessage);
//       } else {
//         _messages.add(
//           ChatMessage(
//             text: 'Error: ${response.statusCode}',
//             isError: true,
//             isUser: false,
//             timestamp: DateTime.now(),
//           ),
//         );
//       }
//     } catch (e) {
//       _messages.add(
//         ChatMessage(
//           text: 'Network error: $e',
//           isUser: false,
//           timestamp: DateTime.now(),
//         ),
//       );
//     }

//     notifyListeners();
//   }
// }
