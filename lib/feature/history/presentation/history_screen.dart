import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/components/placeholder/place_holder.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/feature/history/presentation/widgets/record_container.dart';
import 'package:winr/feature/home/presentation/provider/result_provider.dart';
import 'package:winr/feature/records/presentation/widgets/add_record.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

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
                        onTap: () => showRecordSheet(context, false, null),
                        withButton: true,
                        title: "Win Rate Records",
                        description:
                            "You don't have any recorded win rates yet.",
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: records.length,
                    (context, index) {
                      final record = records[index];
                      return RecordContainer(record: record);
                    },
                  ),
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
