import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController desiredWinRateController =
        TextEditingController();
    final TextEditingController numberOfBattlesController =
        TextEditingController();
    final TextEditingController winRateController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextField 1 → Decimal allowed, max 100
            TextField(
              key: const Key('desiredWinRate'),
              controller: desiredWinRateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [
                WinrateInputFormatter(integersOnly: false, max: 100),
              ],
              decoration: const InputDecoration(
                labelText: 'What is your desired winrate? (by Percentage)',
              ),
            ),
            const SizedBox(height: 12),

            // TextField 2 → Integer only
            TextField(
              key: const Key('numberOfBattles'),
              controller: numberOfBattlesController,
              keyboardType: TextInputType.number,
              inputFormatters: const [
                WinrateInputFormatter(integersOnly: true, max: double.infinity),
              ],
              decoration: const InputDecoration(
                labelText: 'What is your current number of battles?',
              ),
            ),
            const SizedBox(height: 12),

            // TextField 3 → Decimal allowed, max 100
            TextField(
              key: const Key('winRate'),
              controller: winRateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [
                WinrateInputFormatter(integersOnly: false, max: 100),
              ],
              decoration: const InputDecoration(
                labelText: 'What is your winrate? (by Percentage)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
