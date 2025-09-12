import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winr/common/components/container/profile_settings.dart';
import 'package:winr/core/apptext/app_text.dart';
import 'package:winr/core/appthemes/app_themes.dart';

class AppConfiguration extends ConsumerWidget {
  const AppConfiguration({super.key});

  @override
  Widget build(BuildContext contex, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(AppText.configuration, style: TextStyle(fontSize: 16)),
        ),

        ProfileSettingsContainer(
          containerKey: "appearanceKey",
          withSwitch: true,
          title: AppText.appearance,
          icon: Icons.color_lens,
          onTap: () async {
            developer.log(
              "ProfileSettingsContainer",
              name: "ProfileSettingsContainer",
            );
            themeNotifier.toggleTheme();

            final isLightMode = ref.read(themeNotifierProvider);

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            prefs.setBool("theme", isLightMode);
          },
        ),
      ],
    );
  }
}
