import 'package:flutter/services.dart';

class WinrateInputFormatter extends TextInputFormatter {
  final bool integersOnly;
  final double max;
  final int decimalPlaces;

  const WinrateInputFormatter({
    this.integersOnly = false,
    this.max = 100,
    this.decimalPlaces = 5, // default to 5
  });

  // Allow decimals in-progress: "", ".", "12.", "12.3", ".5"
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
      if (_integerRegex.hasMatch(text)) {
        final value = int.tryParse(text);
        if (value == null || value <= max) {
          return newValue;
        }
      }
      return oldValue;
    } else {
      if (_decimalRegex.hasMatch(text)) {
        // ✅ Limit decimal places
        if (text.contains('.')) {
          final parts = text.split('.');
          if (parts.length > 1 && parts[1].length > decimalPlaces) {
            return oldValue; // too many decimal digits
          }
        }

        final value = double.tryParse(text);
        if (value == null || value <= max) {
          return newValue;
        }
      }
      return oldValue;
    }
  }
}
