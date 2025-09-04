import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/buttons/loading_state_notifier.dart';
import 'package:winr/common/components/buttons/regular_button.dart';
import 'package:winr/common/components/snackbar/information_snackbar.dart';
import 'package:winr/common/utils/winrate_input_formatter.dart';
import 'package:winr/core/appmodels/record.dart';
import 'package:winr/feature/history/data/records_database.dart';
import 'package:winr/feature/home/presentation/provider/result_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextField 2 → Integer only
            TextField(
              key: const Key('numberOfBattles'),
              keyboardType: TextInputType.number,
              inputFormatters: const [
                WinrateInputFormatter(integersOnly: true, max: double.infinity),
              ],
              decoration: const InputDecoration(
                labelText: 'What is your current number of battles?',
              ),
              onChanged: (value) =>
                  ref.read(numberOfBattlesProvider.notifier).state = value,
            ),
            const SizedBox(height: 12),

            // TextField 3 → Decimal allowed, max 100
            TextField(
              key: const Key('winRate'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [
                WinrateInputFormatter(integersOnly: false, max: 100),
              ],
              decoration: const InputDecoration(
                labelText: 'What is your current win rate? (in Percentage)',
                suffixText: '%',
              ),
              onChanged: (value) =>
                  ref.read(winRateProvider.notifier).state = value,
            ),
            const SizedBox(height: 12),
            // TextField 1 → Decimal allowed, max 100
            TextField(
              key: const Key('desiredWinRate'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [
                WinrateInputFormatter(integersOnly: false, max: 100),
              ],
              decoration: const InputDecoration(
                labelText: 'What is your desired win rate? (in Percentage)',
                suffixText: '%',
              ),
              onChanged: (value) =>
                  ref.read(desiredWinRateProvider.notifier).state = value,
            ),

            const SizedBox(height: 50),

            // Dynamic text using providers
            Text(
              ref.watch(requiredWinsProvider) ?? "Please enter valid values",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            RegularButton(
              suffixIcon: false,
              withIcon: false,
              text: "Save",
              onTap: () async {
                final requiredWins = ref.read(requiredWinsProvider);

                // ❌ Reject if invalid or already meets target
                if (requiredWins == null) {
                  if (!context.mounted) return;
                  informationSnackBar(
                    context,
                    Icons.error_outline,
                    "Invalid input or you already meet your target.",
                  );
                  return;
                }
                final isLoading = ref.read(
                  regularButtonLoadingProvider.notifier,
                );
                isLoading.setLoading("saveButton", true);

                await Future.delayed(const Duration(seconds: 1));

                final record = WinRateRecords(
                  timeAdded: DateTime.now().millisecondsSinceEpoch,
                  desiredWinRate:
                      int.tryParse(ref.read(desiredWinRateProvider)) ?? 0,
                  currentNumberOfBattles:
                      int.tryParse(ref.read(numberOfBattlesProvider)) ?? 0,
                  currentWinRate: int.tryParse(ref.read(winRateProvider)) ?? 0,
                );

                await RecordDatabase().insertRecord(record);

                isLoading.setLoading("saveButton", false);
                if (!context.mounted) return;
                informationSnackBar(
                  context,
                  Icons.check_circle_outline_outlined,
                  "Record has been saved!",
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.surface,
              buttonKey: "saveButton",
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
