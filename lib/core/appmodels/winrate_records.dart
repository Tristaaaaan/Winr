import 'package:freezed_annotation/freezed_annotation.dart';

part 'winrate_records.freezed.dart';
part 'winrate_records.g.dart';

@freezed
abstract class WinRateRecords with _$WinRateRecords {
  const factory WinRateRecords({
    int? id,
    required int timeAdded,
    int? lastUpdated,
    String? backgroundImage,
    required int desiredWinRate,
    String? name,
    required int currentNumberOfBattles,
    required int currentWinRate,
    int? progressiveWinRate, // ✅ made nullable
  }) = _WinRateRecords;

  factory WinRateRecords.fromJson(Map<String, dynamic> json) =>
      _$WinRateRecordsFromJson(json);

  /// ✅ Manual Map conversion for SQLite
  const WinRateRecords._(); // keep private constructor for methods

  Map<String, dynamic> toMap() => {
    'id': id,
    'timeAdded': timeAdded,
    'lastUpdated': lastUpdated,
    'backgroundImage': backgroundImage,
    'desiredWinRate': desiredWinRate,
    'name': name,
    'currentNumberOfBattles': currentNumberOfBattles,
    'currentWinRate': currentWinRate,
    'progressiveWinRate': progressiveWinRate,
  };

  factory WinRateRecords.fromMap(Map<String, dynamic> map) => WinRateRecords(
    id: map['id'] as int?,
    timeAdded: map['timeAdded'] as int,
    lastUpdated: map['lastUpdated'] as int?,
    backgroundImage: map['backgroundImage'] as String?,
    desiredWinRate: map['desiredWinRate'] as int,
    name: map['name'] as String?,
    currentNumberOfBattles: map['currentNumberOfBattles'] as int,
    currentWinRate: map['currentWinRate'] as int,
    progressiveWinRate: map['progressiveWinRate'] as int?,
  );
}
