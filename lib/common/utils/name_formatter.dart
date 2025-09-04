import 'package:flutter/services.dart';

class MaxLengthFormatter extends TextInputFormatter {
  const MaxLengthFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length <= 15) {
      return newValue;
    }
    // Prevent input beyond 20 chars
    return oldValue;
  }
}
