import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:lextorah_chat_bot/hive/chat_message.dart';

import 'package:lextorah_chat_bot/providers/chat_messages_provider.dart';
import 'package:lextorah_chat_bot/utils/format_timestamp.dart';
import 'package:lextorah_chat_bot/utils/helpers.dart';

class ChatMessages extends ConsumerWidget {
  const ChatMessages({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = [...ref.watch(chatMessagesProvider)]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final groupedMessages = groupMessagesByDate(messages);

    return ListView(
      controller: scrollController,
      children:
          groupedMessages.entries.map((entry) {
            final dateLabel = formatTime(DateTime.parse(entry.key));
            final messages = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      dateLabel,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                ...messages.map(
                  (message) => _buildMessageBubble(message, context, ref),
                ),
              ],
            );
          }).toList(),
    );
  }
}
// class ChatMessages extends ConsumerWidget {
//   const ChatMessages({super.key, required this.scrollController});

//   final ScrollController scrollController;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final messages = [...ref.watch(chatMessagesProvider)]
//       ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

//     return ListView.builder(
//       controller: scrollController,
//       itemCount: messages.length,
//       itemBuilder: (context, index) {
//         final message = messages[index];
//         return _buildMessageBubble(message, context, ref);
//       },
//     );
//   }
// }

Widget _buildMessageBubble(
  ChatMessage message,
  BuildContext context,
  WidgetRef ref,
) {
  final theme = Theme.of(context);

  return Align(
    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: BoxConstraints(),
      margin:
          message.isUser
              ? const EdgeInsets.only(top: 8, bottom: 8, left: 50)
              : const EdgeInsets.only(top: 8, bottom: 8, right: 50),
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
      child:
          message.isTyping
              ? _TypingIndicator()
              : Column(
                crossAxisAlignment:
                    message.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
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

                  const SizedBox(height: 4),
                  Text(
                    DateFormat('hh:mm a').format(message.timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
    ),
  );
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> dotOne;
  late Animation<double> dotTwo;
  late Animation<double> dotThree;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    dotOne = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.3)),
    );
    dotTwo = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6)),
    );
    dotThree = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 0.9)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(dotOne.value),
            const SizedBox(width: 4),
            _buildDot(dotTwo.value),
            const SizedBox(width: 4),
            _buildDot(dotThree.value),
          ],
        );
      },
    );
  }

  Widget _buildDot(double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
    );
  }
}
