import 'package:winr/core/appmodels/record.dart';

abstract class HistoryRepository {
  Future<List<WinRateRecords>> getRecords();
  Future<void> insertRecord(WinRateRecords record);
  Future<void> updateRecord(int id, WinRateRecords record);
  Future<void> deleteRecord(int id);
  Future<void> deleteAllRecords();
  Future<WinRateRecords?> getRecord(int id);
}
