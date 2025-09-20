import 'package:winr/core/appmodels/winrate_records.dart';
import 'package:winr/feature/history/presentation/providers/history_controller.dart';
import 'package:winr/feature/records/domain/record_repo.dart';

class RecordRepositoryImpl implements RecordRepository {
  final HistoryController _historyController;

  RecordRepositoryImpl(this._historyController);

  @override
  Future<void> saveRecord(
    WinRateRecords record, {
    bool isUpdate = false,
  }) async {
    if (isUpdate && record.id != null) {
      await _historyController.updateRecord(record.id!, record);
    } else {
      await _historyController.addRecord(record);
    }
  }
}
