import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winr/common/components/container/profile_settings.dart';
import 'package:winr/core/apptext/app_text.dart';

class AboutApp extends ConsumerWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(AppText.aboutApp, style: TextStyle(fontSize: 16)),
        ),

        ProfileSettingsContainer(
          withSwitch: false,
          title: AppText.appVersion,
          icon: Icons.verified_user_outlined,
          onTap: () {
            context.push('/version');
          },
        ),
        ProfileSettingsContainer(
          withSwitch: false,
          title: "Privacy Policy",
          icon: Icons.info_outline,
          onTap: () async {
            Uri url = Uri.parse(
              "https://www.termsfeed.com/live/82b80e8a-eba0-4bc7-9026-de86abda1c4b",
            );

            await launchUrl(url, mode: LaunchMode.externalApplication);
          },
        ),
        ProfileSettingsContainer(
          withSwitch: false,
          title: "Terms and Conditions",
          icon: Icons.info_outline,
          onTap: () async {
            Uri url = Uri.parse(
              "https://www.termsfeed.com/live/852658c3-d877-4de7-9ed8-f8fd3c0e0af6",
            );
            await launchUrl(url, mode: LaunchMode.externalApplication);
          },
        ),
        ProfileSettingsContainer(
          withSwitch: false,
          title: "Contact Us",
          icon: Icons.contact_support_outlined,
          onTap: () async {
            Uri url = Uri.parse(
              "mailto:winrcalculator.official@gmail.com?subject=Contact",
            );

            await launchUrl(url, mode: LaunchMode.externalApplication);
          },
        ),
      ],
    );
  }
}
