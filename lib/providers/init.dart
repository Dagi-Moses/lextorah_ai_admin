import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lextorah_chat_bot/providers/auth_provider.dart';
import 'package:lextorah_chat_bot/src/const.dart';
import 'package:lextorah_chat_bot/utils/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appInitProvider = AsyncNotifierProvider<AppInitNotifier, void>(
  () => AppInitNotifier(),
);

class AppInitNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    prefs = await SharedPreferences.getInstance();
    await initHive();
    await ref.read(authProvider.notifier).tryAutoLogin();
  }
}
