import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lextorah_chat_bot/admin/components/nav_item.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';
import 'package:lextorah_chat_bot/src/routes.dart';
import 'package:lextorah_chat_bot/utils/screen_helper.dart';

// Adjust import

class SideMenu extends ConsumerStatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final isTablet = ScreenHelper.isTablet(context);

    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isTablet ? 80 : 200,
      color: theme.colorScheme.primary,
      child: Column(
        crossAxisAlignment:
            isTablet ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child:
                isTablet
                    ? Tooltip(
                      message: "LextOrah School anguages",
                      child: Icon(Icons.school),
                    )
                    : Image.asset("assets/logo.png", scale: 7),
          ),

          buildNavItem(
            context: context,
            icon: Icons.upload_file,
            label: 'Upload Document',
            route: AppRoutePath.upload,
          ),
          Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,

            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title:
                  isTablet
                      ? null
                      : Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                ref.read(authProvider.notifier).logout();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
