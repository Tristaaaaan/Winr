import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/core/appthemes/app_themes.dart';

class StatisticItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? Colors.white
                : withImage
                    ? Colors.white70
                    : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isDark
                ? Colors.white
                : withImage
                    ? Colors.white70
                    : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
