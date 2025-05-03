import 'package:intl/intl.dart';
import 'package:lextorah_chat_bot/hive/chat_message.dart';

Map<String, List<ChatMessage>> groupMessagesByDate(List<ChatMessage> messages) {
  final Map<String, List<ChatMessage>> grouped = {};

  for (final message in messages) {
    final dateKey = DateFormat('yyyy-MM-dd').format(message.timestamp);
    grouped.putIfAbsent(dateKey, () => []).add(message);
  }

  return grouped;
}
