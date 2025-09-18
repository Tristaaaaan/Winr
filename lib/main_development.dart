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
  AppConfig.setEnvironment(Flavors.development);

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

// Future<void> initializeSettings(WidgetRef ref, BuildContext context) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final bool theme = prefs.getBool('theme') ?? false;

//   final themeNotifier = ref.read(themeNotifierProvider.notifier);
//   themeNotifier.setTheme(theme);

//   // if (AppConfig.environment == Flavors.production) {
//   //   final newVersion = NewVersionPlus(
//   //     androidId: 'com.tristans.suri',
//   //     androidPlayStoreCountry: "en_US",
//   //     androidHtmlReleaseNotes: true,
//   //   );
//   // if (context.mounted) {
//   //   await advancedStatusCheck(newVersion, context);
//   // }
//   // }
// }

// Future<void> advancedStatusCheck(
//   NewVersionPlus newVersion,
//   BuildContext context,
// ) async {
//   final status = await newVersion.getVersionStatus();
//   if (status != null) {
//     if (status.localVersion != status.storeVersion) {
//       if (context.mounted) {
//         await showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Time for an Update!'),
//             content: const Text(
//               'We’ve got a new version ready for you. Update now to enjoy the latest improvements.',
//             ),
//             actions: [
//               TextButton(
//                 child: const Text('Update'),
//                 onPressed: () async {
//                   Uri url = Uri.parse(
//                     "https://play.google.com/store/apps/details?id=com.tristans.suri",
//                   );

//                   await launchUrl(url, mode: LaunchMode.externalApplication);
//                 },
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }
// }
