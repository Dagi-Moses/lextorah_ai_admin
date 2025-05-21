import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lextorah_chat_bot/hive/chat_message.dart';
import 'package:lextorah_chat_bot/providers/chat_controller_provider.dart';
import 'package:lextorah_chat_bot/providers/chat_messages_provider.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({super.key});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  // controller for the input field
  final TextEditingController textController = TextEditingController();

  final FocusNode textFieldFocus = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> sendChatMessage() async {
    final String message = textController.text.trim();
    if (message.isEmpty) return;

    final chatNotifier = ref.read(chatMessagesProvider.notifier);

    // 1. Add user message
    await chatNotifier.addMessage(ChatMessage(text: message, isUser: true));

    textController.clear();

    await chatNotifier.addMessage(ChatMessage(text: '', isTyping: true));

    try {
      await ref.read(chatControllerProvider).sendMessage(context, message);
    } catch (e) {
      log('Error sending message: $e');
    } finally {
      textFieldFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: textFieldFocus,
                  controller: textController,
                  maxLines: 20,

                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.send,
                  onFieldSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      // send the message
                      sendChatMessage();
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    hintText: 'type your questions here...',
                    hintStyle: TextStyle(fontSize: 12),

                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Theme.of(context).textTheme.titleLarge!.color!,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // send the message
                  sendChatMessage();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      size: 20,
                      // Icons.arrow_upward,
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
