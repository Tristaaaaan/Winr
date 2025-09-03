import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/placeholder/place_holder.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/feature/home/presentation/provider/result_provider.dart';

class HistoryScreen extends ConsumerWidget {
  final VoidCallback onGoHome;
  const HistoryScreen({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(recordsStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          recordsAsync.when(
            data: (records) {
              if (records.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: DataPlaceHolder(
                      imagePath: AppImages.noData,
                      imageHeight: 300,
                      imageWidth: 300,
                      onTap: () => onGoHome(),
                      withButton: true,
                      title: " Win Rate Records",
                      description: "You don't have any recorded win rates yet.",
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final record = records[index];
                  return ListTile(
                    title: Text('Win Rate: ${record.currentWinRate}%'),
                    subtitle: Text(
                      'Battles: ${record.currentNumberOfBattles} • Desired: ${record.desiredWinRate}%',
                    ),
                    trailing: Text(
                      DateTime.fromMillisecondsSinceEpoch(
                        record.timestamp,
                      ).toLocal().toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }, childCount: records.length),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, st) =>
                SliverFillRemaining(child: Center(child: Text('Error: $err'))),
          ),
        ],
      ),
    );
  }
}
