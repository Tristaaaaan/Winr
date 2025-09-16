import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winr/core/appmodels/winrate_records.dart';

part 'history_states.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = _Initial;
  const factory HistoryState.loading() = _Loading;
  const factory HistoryState.loaded({List<WinRateRecords>? record}) = _Loaded;
  const factory HistoryState.error(String message) = _Error;
  const factory HistoryState.empty() = _Empty;
}
