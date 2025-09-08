import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:winr/common/components/loading/record_loading.dart';
import 'package:winr/common/components/placeholder/place_holder.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/feature/history/presentation/providers/history_controller.dart';
import 'package:winr/feature/history/presentation/widgets/record_container.dart';
import 'package:winr/feature/records/presentation/widgets/add_record.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(historyControllerProvider);
    Future<void> refreshRecord() async {
      await ref.read(historyControllerProvider.notifier).refreshStory();
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshRecord,
          child: CustomScrollView(
            slivers: [
              // 🔹 Handle all states consistently as Slivers
              records.when(
                initial: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                loading: () => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[300]!,
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => const RecordLoading(),
                      ),
                    ),
                  ),
                ),

                error: (message) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: DataPlaceHolder(
                      buttonText: "Try Again",
                      imagePath: AppImages.errorImage,
                      imageHeight: 300,
                      imageWidth: 300,
                      onTap: refreshRecord,
                      withButton: false,
                      title: "Error",
                      description: "Seems like something went wrong.",
                    ),
                  ),
                ),
                empty: () => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: DataPlaceHolder(
                      buttonText: "Add Record",
                      imagePath: AppImages.noData,
                      imageHeight: 300,
                      imageWidth: 300,
                      onTap: () => showRecordSheet(context, false, null),
                      withButton: true,
                      title: "Win Rate Records",
                      description: "You don't have any recorded win rates yet.",
                    ),
                  ),
                ),
                loaded: (records) => SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final record = records[index];
                    return RecordContainer(record: record);
                  }, childCount: records!.length),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight + 15,
                  // 🔹 +80 leaves room for FAB too
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
