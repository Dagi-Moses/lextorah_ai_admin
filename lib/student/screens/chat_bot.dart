import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lextorah_chat_bot/hive/chat_message.dart';
import 'package:lextorah_chat_bot/providers/chat_messages_provider.dart';
import 'package:lextorah_chat_bot/student/components/bottom_chat_widget.dart';
import 'package:lextorah_chat_bot/student/components/chat_messages.dart';
import 'package:lextorah_chat_bot/utils/screen_helper.dart';

class ChatBot extends ConsumerStatefulWidget {
  const ChatBot({super.key});

  @override
  ConsumerState<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatBot> {
  // scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.listen<List<ChatMessage>>(chatMessagesProvider, (previous, next) {
        if (next.isNotEmpty) {
          _scrollToBottom();
        }
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0.0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    if (messages.isNotEmpty) {
      _scrollToBottom();
    }
    final isDesktop = ScreenHelper.isDesktop(context);
    final isTablet = ScreenHelper.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal:
                isDesktop
                    ? 50
                    : isTablet
                    ? 30
                    : 10,
          ),
          child: Column(
            children: [
              Expanded(
                child:
                    messages.isEmpty
                        ? const Center(
                          child: Text(
                            'No messages yet',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        )
                        : ChatMessages(scrollController: _scrollController),
              ),

              // input field
              BottomChatField(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Tutor',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Online',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
