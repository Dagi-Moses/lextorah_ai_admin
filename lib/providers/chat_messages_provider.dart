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
}
