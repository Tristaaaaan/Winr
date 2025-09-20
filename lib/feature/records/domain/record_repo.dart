import 'package:winr/core/appmodels/winrate_records.dart';

abstract class RecordRepository {
  Future<void> saveRecord(WinRateRecords record, {bool isUpdate = false});
}
