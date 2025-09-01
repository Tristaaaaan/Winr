import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/config/app_config.dart';
import 'package:winr/config/app_environments.dart';

import 'core/approutes/app_routes.dart';
import 'core/appthemes/app_themes.dart';

void main() {
  AppConfig.setEnvironment(Flavors.production);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider);
    final theme = isDarkMode ? ThemeNotifier.darkMode : ThemeNotifier.lightMode;

    return MaterialApp.router(
      theme: theme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
