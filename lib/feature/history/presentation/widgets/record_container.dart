import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/utils/calculate_winrate.dart';
import 'package:winr/core/appmodels/record.dart';
import 'package:winr/feature/history/presentation/providers/result_provider.dart';
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
        ref.read(uploadImageNameProvider.notifier).state = [];
        ref.read(uploadImagePathProvider.notifier).state = [];
        ref.read(uploadImagePathNameProvider.notifier).state = [];
        // reset inputs instead of requiredWinsProvider
        ref.read(desiredWinRateProvider.notifier).state = "0";
        ref.read(numberOfBattlesProvider.notifier).state = "0";
        ref.read(winRateProvider.notifier).state = "0";
        showRecordSheet(context, true, record);
      },
      child: Container(
        margin: const EdgeInsets.all(12),

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
          padding: const EdgeInsets.all(15),
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
                      ).colorScheme.primary.withValues(alpha: 0.5),
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
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First row
                    Row(
                      children: [
                        Expanded(
                          child: StatisticItem(
                            withImage: record.backgroundImage != null,
                            label: "Current Win Rate",
                            value: "${record.currentWinRate}%",
                          ),
                        ),
                        Expanded(
                          child: StatisticItem(
                            withImage: record.backgroundImage != null,
                            label: record.currentNumberOfBattles == 1
                                ? "Match"
                                : "Matches",
                            value: "${record.currentNumberOfBattles}",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Second row
                    Text.rich(
                      TextSpan(
                        text: "You need to win ",
                        style: TextStyle(
                          color: record.backgroundImage != null
                              ? Colors.white70
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: "$neededWins",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                " ${(neededWins == 1) ? "battle" : "battles"} consecutively to reach ",
                          ),
                          TextSpan(
                            text: "${record.desiredWinRate}%",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: " win rate."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
