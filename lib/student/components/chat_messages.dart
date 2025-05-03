import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lextorah_chat_bot/hive/chat_message.dart';
import 'package:lextorah_chat_bot/providers/chat_messages_provider.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = [...ref.watch(chatMessagesProvider)]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message, context);
      },
    );
  }
}

Widget _buildMessageBubble(ChatMessage message, BuildContext context) {
  final theme = Theme.of(context);
  return Align(
    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: BoxConstraints(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color:
            message.isError
                ? theme.colorScheme.errorContainer
                : message.isUser
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        softWrap: true,
        message.text,
        style: TextStyle(
          color:
              message.isError
                  ? theme.colorScheme.onErrorContainer
                  : message.isUser
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ),
  );
}
