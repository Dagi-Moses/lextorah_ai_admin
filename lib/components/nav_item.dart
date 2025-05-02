import 'package:flutter/material.dart';
import 'package:lextorah_chat_bot/utils/screen_helper.dart';

// Widget _buildNavItem(
//   BuildContext context,
//   IconData icon,
//   String label, {
//   bool selected = false,
// }) {
//   final theme = Theme.of(context);
//   return ListTile(
//     selected: selected,
//     selectedTileColor: theme.colorScheme.secondaryContainer,
//     leading: Icon(icon, color: theme.colorScheme.onPrimary),
//     title: Text(label, style: TextStyle(color: theme.colorScheme.onPrimary)),
//     onTap: () {},
//   );
// }

Widget buildNavItem(
  BuildContext context,
  IconData icon,
  String label, {
  bool selected = false,
  VoidCallback? onTap,
}) {
  final theme = Theme.of(context);
  final isTablet = ScreenHelper.isTablet(context);

  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: Tooltip(
      message: isTablet ? label : '',
      child: IntrinsicWidth(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
            color:
                selected
                    ? theme.colorScheme.secondaryContainer
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            hoverColor: theme.colorScheme.secondary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Row(
                mainAxisAlignment:
                    isTablet
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color:
                        selected
                            ? theme.colorScheme.onSecondaryContainer
                            : theme.colorScheme.onPrimary,
                  ),
                  if (!isTablet) ...[
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color:
                            selected
                                ? theme.colorScheme.onSecondaryContainer
                                : theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
