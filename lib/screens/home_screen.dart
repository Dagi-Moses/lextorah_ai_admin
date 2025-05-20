import 'package:flutter/material.dart';

import 'package:lextorah_chat_bot/utils/screen_helper.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  final Widget sideMenu; // 👈 Add this

  const HomeScreen({super.key, required this.child, required this.sideMenu});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final smallScreen = ScreenHelper.isMobile(context);

    return Scaffold(
      appBar:
          smallScreen
              ? AppBar(
                title: const Text('Lextorah'),
                backgroundColor: theme.colorScheme.primary,
                centerTitle: true,
              )
              : null,
      drawer: smallScreen ? Drawer(child: sideMenu) : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [if (!smallScreen) sideMenu, Expanded(child: child)],
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   final Widget child;

//   const HomeScreen({super.key, required this.child});
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final smallScreen = ScreenHelper.isMobile(context);
//     return Scaffold(
//       appBar:
//           smallScreen
//               ? AppBar(
//                 title: const Text('Lextorah '),
//                 backgroundColor: theme.colorScheme.primary,
//                 centerTitle: true,
//               )
//               : null,
//       drawer: smallScreen ? Drawer(child: SideMenu()) : null,
//       body: SafeArea(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           //mainAxisSize: MainAxisSize.min,
//           children: [
//             if (!smallScreen) SideMenu(),
//             Expanded(
//               child: Container(
//                 // padding: const EdgeInsets.only(
//                 //     top: 12, bottom: 12, left: 12, right: 12),
//                 child: child,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
