import 'package:flutter/material.dart';

class StatisticItem extends StatelessWidget {
  final String label;
  final String value;
  final bool withImage;
  const StatisticItem({
    super.key,
    required this.label,
    required this.value,
    this.withImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: withImage ? Colors.white70 : Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: withImage ? Colors.white70 : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
