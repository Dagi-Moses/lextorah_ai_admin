import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lextorah_chat_bot/hive/chat_message.dart';

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(
      (ref) => ChatMessagesNotifier(),
    );

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final box = await Hive.openBox<ChatMessage>('chatBox');
    state = box.values.toList();
  }

  Future<void> addMessage(ChatMessage message) async {
    final box = await Hive.openBox<ChatMessage>('chatBox');
    await box.add(message);
    state = [...state, message];
  }

  Future<void> deleteAllMessages() async {
    final box = await Hive.openBox<ChatMessage>('chatBox');
    await box.clear();
    state = []; // clear your in-memory state list too
  }

  Future<void> removeTypingIndicator() async {
    final box = await Hive.openBox<ChatMessage>('chatBox');

    // Collect keys of typing messages
    final keysToDelete =
        box.keys.where((key) {
          final msg = box.get(key);
          return msg != null && msg.isTyping;
        }).toList();

    // Delete them from the box
    await box.deleteAll(keysToDelete);

    // Reload state from the box
    state = box.values.toList();
  }
}
