import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/utils/calculate_winrate.dart';
import 'package:winr/core/appmodels/record.dart';
import 'package:winr/feature/history/presentation/widgets/statistic_item.dart';
import 'package:winr/feature/records/presentation/providers/image_providers.dart';

import '../../../records/presentation/widgets/add_record.dart';

class RecordContainer extends ConsumerWidget {
  final WinRateRecords record;
  const RecordContainer({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Decode base64 image
    Uint8List? backgroundImage;
    if (record.backgroundImage != null && record.backgroundImage!.isNotEmpty) {
      backgroundImage = base64Decode(record.backgroundImage!);
    }

    // Calculate needed wins
    final neededWins = calculateNeededWins(
      desiredWinRate: record.desiredWinRate,
      currentNumberOfBattles: record.currentNumberOfBattles,
      currentWinRate: record.currentWinRate,
    );

    return GestureDetector(
      onTap: () {
        developer.log("Record: ${record.id}");
        ref.read(isImageRemovedProvider.notifier).state = false;

        showRecordSheet(context, true, record);
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: backgroundImage != null
              ? DecorationImage(
                  image: MemoryImage(backgroundImage),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: backgroundImage != null
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .3),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.9),
                    ),
                    child: Text(
                      record.name?.toUpperCase() ?? "          ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_outlined,
                    size: 24,
                    color: record.backgroundImage != null
                        ? Colors.white
                        : Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats in rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatisticItem(
                    withImage: record.backgroundImage != null,
                    label: "Current Win Rate",
                    value: "${record.currentWinRate}%",
                  ),
                  StatisticItem(
                    withImage: record.backgroundImage != null,
                    label: "Battles",
                    value: "${record.currentNumberOfBattles}",
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatisticItem(
                    withImage: record.backgroundImage != null,
                    label: "Desired Win Rate",
                    value: "${record.desiredWinRate}%",
                  ),
                  StatisticItem(
                    label: "Needed Wins",
                    value: "$neededWins",
                    withImage: record.backgroundImage != null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
