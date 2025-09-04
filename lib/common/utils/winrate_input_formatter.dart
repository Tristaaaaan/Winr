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
