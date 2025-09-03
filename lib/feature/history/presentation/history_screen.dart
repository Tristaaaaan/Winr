import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/feature/home/presentation/provider/result_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(recordsStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(pinned: true, title: Text('Records')),
          recordsAsync.when(
            data: (records) {
              if (records.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No records yet')),
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
