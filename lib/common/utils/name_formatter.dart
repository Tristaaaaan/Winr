import 'package:flutter/services.dart';

class MaxLengthFormatter extends TextInputFormatter {
  final int maxLength;
  const MaxLengthFormatter({this.maxLength = 50});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length <= maxLength) return newValue;

    final truncated = newValue.text.substring(0, maxLength);
    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: maxLength),
    );
  }
}
