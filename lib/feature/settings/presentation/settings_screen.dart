import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/buttons/loading_state_notifier.dart';
import 'package:winr/common/components/buttons/regular_button.dart';
import 'package:winr/common/components/snackbar/information_snackbar.dart';
import 'package:winr/feature/history/presentation/providers/history_controller.dart';
import 'package:winr/feature/settings/presentation/widgets/about_app.dart';
import 'package:winr/feature/settings/presentation/widgets/configuration.dart';
import 'package:winr/feature/settings/presentation/widgets/feedback_and_suggestions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                AppConfiguration(),
                SizedBox(height: 25),
                BugSuggestionsReport(),
                SizedBox(height: 25),
                AboutApp(),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RegularButton(
                    suffixIcon: false,
                    withIcon: false,
                    text: "Delete All Records",
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
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.error,
                                ),
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm != true) return;

                      final isLoading = ref.read(
                        regularButtonLoadingProvider.notifier,
                      );
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
                        isLoading.setLoading("deleteAllRecords", false);
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.surface,
                    buttonKey: "deleteAllRecords",
                    width: double.infinity,
                  ),
                ),
              ]),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 25,
                // 🔹 +80 leaves room for FAB too
              ),
            ),
          ],
        ),
      ),
    );
  }
}
