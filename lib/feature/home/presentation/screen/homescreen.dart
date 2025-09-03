import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/buttons/regular_button.dart';
import 'package:winr/feature/home/presentation/provider/result_provider.dart';

class WinrateInputFormatter extends TextInputFormatter {
  final bool integersOnly;
  final double max;

  const WinrateInputFormatter({this.integersOnly = false, this.max = 100});

  // Allow decimals while typing: "", ".", "12.", "12.3", ".5"
  static final _decimalRegex = RegExp(r'^(?:\d+|\d+\.\d*|\.\d+)?$');
  // Integers only
  static final _integerRegex = RegExp(r'^\d*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Always allow clear
    if (text.isEmpty) return newValue;

    if (integersOnly) {
      // Accept only digits
      if (_integerRegex.hasMatch(text)) {
        final value = int.tryParse(text);
        if (value == null || value <= max) {
          return newValue;
        }
      }
      return oldValue;
    } else {
      // Accept decimals in-progress
      if (_decimalRegex.hasMatch(text)) {
        final value = double.tryParse(text);
        // if parse fails (like "." or "12.") → allow temporarily
        if (value == null || value <= max) {
          return newValue;
        }
      }
      return oldValue;
    }
  }
}

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
                labelText: 'What is your desired winrate? (by Percentage)',
              ),
              onChanged: (value) =>
                  ref.read(desiredWinRateProvider.notifier).state = value,
            ),
            const SizedBox(height: 12),

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
                labelText: 'What is your winrate? (by Percentage)',
              ),
              onChanged: (value) =>
                  ref.read(winRateProvider.notifier).state = value,
            ),
            const SizedBox(height: 50),

            // Dynamic text using providers
            Text(ref.watch(requiredWinsProvider)),
            const SizedBox(height: 20),

            RegularButton(
              suffixIcon: false,
              withIcon: false,
              text: "Save",
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
