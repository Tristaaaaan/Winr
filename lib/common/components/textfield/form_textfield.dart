import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormTextField extends ConsumerStatefulWidget {
  final String fieldKey;
  final List<TextInputFormatter>? inputFormatters;
  final String labelText;
  final void Function(String)? onChanged;
  final bool isUpdate;
  final String? initialValue;

  const FormTextField({
    super.key,
    required this.fieldKey,
    this.inputFormatters,
    required this.labelText,
    this.onChanged,
    this.isUpdate = false,
    this.initialValue,
  });

  @override
  ConsumerState<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends ConsumerState<FormTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final initialText = widget.isUpdate ? widget.initialValue ?? "" : "";
    _controller = TextEditingController(text: initialText);

    // Push initial value into provider if editing
    if (initialText.isNotEmpty && widget.onChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged!(initialText);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: Key(widget.fieldKey),
      controller: _controller,
      keyboardType: TextInputType.text,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(labelText: widget.labelText),
      onChanged: widget.onChanged,
    );
  }
}
