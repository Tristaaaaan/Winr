import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winr/common/components/buttons/loading_state_notifier.dart';
import 'package:winr/common/components/container/profile_settings.dart';
import 'package:winr/common/components/snackbar/information_snackbar.dart';
import 'package:winr/core/apptext/app_text.dart';
import 'package:winr/core/appthemes/app_themes.dart';
import 'package:winr/feature/history/presentation/providers/history_controller.dart';
import 'package:winr/feature/history/presentation/providers/result_provider.dart';

class AppConfiguration extends ConsumerWidget {
  const AppConfiguration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            themeNotifier.toggleTheme();

            final isLightMode = ref.read(themeNotifierProvider);

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            prefs.setBool("theme", isLightMode);
          },
        ),
        ProfileSettingsContainer(
          withSwitch: false,
          title: "Clear Records",
          icon: Icons.delete_forever_outlined,
          onTap: () async {
            if (!context.mounted) return;

            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Record Deletion"),
                  content: const Text(
                    "Are you sure you want to delete all the record? This action cannot be undone.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: const Text("Delete"),
                    ),
                  ],
                );
              },
            );

            if (confirm != true) return;

            final isLoading = ref.read(regularButtonLoadingProvider.notifier);
            isLoading.setLoading("deleteAllRecords", true);

            try {
              await ref
                  .read(historyControllerProvider.notifier)
                  .deleteAllRecords();

              if (!context.mounted) return;
              informationSnackBar(
                context,
                Icons.delete_outline,
                "Records has been deleted!",
              );
            } finally {
              ref.invalidate(requiredWinsProvider);
              ref.invalidate(desiredWinRateProvider);
              ref.invalidate(numberOfBattlesProvider);
              ref.invalidate(winRateProvider);
              isLoading.setLoading("deleteAllRecords", false);
            }
          },
        ),
      ],
    );
  }
}
