import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/core/appmodels/record.dart';
import 'package:winr/feature/history/data/history_repo_impl.dart';
import 'package:winr/feature/history/domain/history_repo.dart';
import 'package:winr/feature/history/presentation/providers/history_states.dart';

final historyControllerProvider =
    StateNotifierProvider<HistoryController, HistoryState>(
  (ref) => HistoryController(ref.watch(historyRepositoryProvider)),
);

class HistoryController extends StateNotifier<HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryController(this._historyRepository)
      : super(const HistoryState.initial()) {
    getHistory();
  }

  Future<void> getHistory() async {
    state = const HistoryState.loading();

    try {
      final storyInfo = await _historyRepository.getRecords();
      if (storyInfo.isEmpty) {
        state = const HistoryState.empty();
      } else {
        state = HistoryState.loaded(record: storyInfo);
      }
    } catch (e) {
      state = HistoryState.error(e.toString());
    }
  }

  Future<void> refreshStory() async {
    await getHistory();
  }

  // 🔹 CRUD wrappers with refresh
  Future<void> addRecord(WinRateRecords record) async {
    await _historyRepository.insertRecord(record);
    await getHistory();
  }

  Future<void> updateRecord(int id, WinRateRecords record) async {
    await _historyRepository.updateRecord(id, record);
    await getHistory();
  }

  Future<void> deleteRecord(int id) async {
    await _historyRepository.deleteRecord(id);
    await getHistory();
  }

  Future<void> deleteAllRecords() async {
    await _historyRepository.deleteAllRecords();
    await getHistory();
  }
}
