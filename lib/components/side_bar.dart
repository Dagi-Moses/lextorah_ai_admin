import 'package:flutter/material.dart';
import 'package:lextorah_chat_bot/components/nav_item.dart';
import 'package:lextorah_chat_bot/utils/screen_helper.dart';

// Adjust import

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;

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
            context,
            Icons.upload_file,
            'Upload Document',
            selected: true,
          ),

          //buildNavItem(context, Icons.settings, 'Settings'),
        ],
      ),
    );
  }
}
