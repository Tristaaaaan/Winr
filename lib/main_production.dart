import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:winr/config/app_config.dart';
import 'package:winr/config/app_environments.dart';
import 'package:winr/feature/history/data/records_database.dart';

import 'core/approutes/app_routes.dart';
import 'core/appthemes/app_themes.dart';

void main() async {
  AppConfig.setEnvironment(Flavors.production);
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());

  await RecordDatabase().initializeDatabase();

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
