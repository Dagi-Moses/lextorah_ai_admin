import 'package:flutter/material.dart';

class StudentChatScreen extends StatelessWidget {
  const StudentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: theme.colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  child: Text(
                    'School AI Assistant',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                _buildNavItem(context, Icons.home, 'Home'),
                _buildNavItem(context, Icons.chat, 'Chat', selected: true),
                _buildNavItem(context, Icons.help, 'Help'),
              ],
            ),
          ),

          // Chat Section
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.dividerColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.smart_toy, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'School AI Assistant - Online',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildMessageBubble(
                        'When does the next semester begin?',
                        isUser: true,
                        context: context,
                      ),
                      _buildMessageBubble(
                        'The next semester begins on September 1st. Is there anything else I can assist you with?',
                        isUser: false,
                        context: context,
                      ),
                      _buildMessageBubble(
                        'How do I reset my password?',
                        isUser: true,
                        context: context,
                      ),
                      _buildMessageBubble(
                        'To reset your password, please visit the following link...',
                        isUser: false,
                        context: context,
                      ),
                      _buildMessageBubble(
                        'An error occurred. Please try again.',
                        isUser: false,
                        isError: true,
                        context: context,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Message',
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mic, color: theme.colorScheme.primary),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label, {
    bool selected = false,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      selected: selected,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      leading: Icon(icon, color: theme.colorScheme.onPrimary),
      title: Text(label, style: TextStyle(color: theme.colorScheme.onPrimary)),
      onTap: () {},
    );
  }

  Widget _buildMessageBubble(
    String text, {
    required bool isUser,
    bool isError = false,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              isError
                  ? theme.colorScheme.errorContainer
                  : isUser
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isError
                    ? theme.colorScheme.onErrorContainer
                    : isUser
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
