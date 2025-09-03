import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/placeholder/place_holder.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/feature/home/presentation/provider/result_provider.dart';
import 'package:winr/feature/records/presentation/widgets/add_record.dart';

class HistoryScreen extends ConsumerWidget {
  final VoidCallback onGoHome;
  const HistoryScreen({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(recordsStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
                        title: "Win Rate Records",
                        description:
                            "You don't have any recorded win rates yet.",
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final record = records[index];
                    return GestureDetector(
                      onTap: () {
                        showRecordSheet(context, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Current Win Rate: ${record.desiredWinRate}%"),
                            Text(
                              "Current Number of Battles: ${record.currentNumberOfBattles}",
                            ),
                            Text("Desired Win Rate: ${record.desiredWinRate}%"),
                          ],
                        ),
                      ),
                    );

                    // ListTile(
                    //   title: Text('Win Rate: ${record.currentWinRate}%'),
                    //   subtitle: Text(
                    //     'Battles: ${record.currentNumberOfBattles} • Desired: ${record.desiredWinRate}%',
                    //   ),
                    //   trailing: Text(
                    //     DateTime.fromMillisecondsSinceEpoch(
                    //       record.timestamp,
                    //     ).toLocal().toString(),
                    //     style: const TextStyle(fontSize: 12),
                    //   ),
                    // );
                  }, childCount: records.length),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, st) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
