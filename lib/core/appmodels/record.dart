import 'package:freezed_annotation/freezed_annotation.dart';

part 'record.freezed.dart';
part 'record.g.dart';

@freezed
class WinRateRecords with _$WinRateRecords {
  const WinRateRecords._();

  const factory WinRateRecords({
    int? id, // PRIMARY KEY AUTOINCREMENT
    required int timestamp,
    String? backgroundImage,
    required int desiredWinRate,
    required int currentNumberOfBattles,
    required int currentWinRate,
    int? progressiveWinRate, // ✅ made nullable
  }) = _WinRateRecords;

  factory WinRateRecords.fromJson(Map<String, dynamic> json) =>
      _$WinRateRecordsFromJson(json);

  /// ✅ Manual Map conversion for SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'timestamp': timestamp,
    'backgroundImage': backgroundImage,
    'desiredWinRate': desiredWinRate,
    'currentNumberOfBattles': currentNumberOfBattles,
    'currentWinRate': currentWinRate,
    'progressiveWinRate': progressiveWinRate, // stays null if not set
  };

  factory WinRateRecords.fromMap(Map<String, dynamic> map) => WinRateRecords(
    id: map['id'] as int?,
    timestamp: map['timestamp'] as int,
    backgroundImage: map['backgroundImage'] as String?,
    desiredWinRate: map['desiredWinRate'] as int,
    currentNumberOfBattles: map['currentNumberOfBattles'] as int,
    currentWinRate: map['currentWinRate'] as int,
    progressiveWinRate: map['progressiveWinRate'] as int?, // ✅ allow null
  );
}
