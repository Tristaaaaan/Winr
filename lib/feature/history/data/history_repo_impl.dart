import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/core/appmodels/winrate_records.dart';
import 'package:winr/feature/history/data/records_database.dart';
import 'package:winr/feature/history/domain/history_repo.dart';

// 🔹 Repository provider
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(ref.watch(recordDatabaseProvider));
});

class HistoryRepositoryImpl implements HistoryRepository {
  final RecordDatabase _recordDatabase;

  HistoryRepositoryImpl(this._recordDatabase);

  @override
  Future<List<WinRateRecords>> getRecords() {
    return _recordDatabase.getRecords();
  }

  @override
  Future<void> insertRecord(WinRateRecords record) {
    return _recordDatabase.insertRecord(record);
  }

  @override
  Future<void> updateRecord(int id, WinRateRecords record) {
    return _recordDatabase.updateRecord(id, record);
  }

  @override
  Future<void> deleteRecord(int id) {
    return _recordDatabase.deleteRecord(id);
  }

  @override
  Future<void> deleteAllRecords() {
    return _recordDatabase.deleteAllRecords();
  }

  @override
  Future<WinRateRecords?> getRecord(int id) {
    return _recordDatabase.getRecord(id);
  }
}
