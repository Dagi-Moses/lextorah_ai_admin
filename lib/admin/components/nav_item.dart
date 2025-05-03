import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/utils/screen_helper.dart';

Widget buildNavItem({
  required BuildContext context,
  required IconData icon,
  required String label,
  required String route,
}) {
  final theme = Theme.of(context);
  final isTablet = ScreenHelper.isTablet(context);
  final currentRoute = GoRouterState.of(context).uri.toString();
  final isSelected = currentRoute == route;

  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: Tooltip(
      message: isTablet ? label : '',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.secondaryContainer
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            if (!isSelected) {
              context.go(route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          hoverColor: theme.colorScheme.secondary.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              mainAxisAlignment:
                  isTablet ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color:
                      isSelected
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
                          isSelected
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
  );
}
