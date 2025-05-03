import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 2)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final bool isError;

  @HiveField(3)
  final DateTime timestamp;

  ChatMessage({
    this.isError = false,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
