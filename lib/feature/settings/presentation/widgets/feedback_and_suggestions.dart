import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winr/core/apptext/app_text.dart';

import '../../../../common/components/container/profile_settings.dart';

class BugSuggestionsReport extends ConsumerWidget {
  const BugSuggestionsReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(AppText.bugAndSuggestion, style: TextStyle(fontSize: 16)),
        ),
        ProfileSettingsContainer(
          withSwitch: false,
          title: "Submit Suggestions / Feedback",
          icon: Icons.feedback_outlined,
          onTap: () async {
            Uri url = Uri.parse("https://forms.gle/aSeGR1CEsvvpRthi7");
            await launchUrl(url, mode: LaunchMode.externalApplication);
          },
        ),
        ProfileSettingsContainer(
          withSwitch: false,
          title: "Report a Bug",
          icon: Icons.bug_report_outlined,
          onTap: () async {
            Uri url = Uri.parse("https://forms.gle/QMxyk4X7FdA43pSi9");
            await launchUrl(url, mode: LaunchMode.externalApplication);
          },
        ),
      ],
    );
  }
}
