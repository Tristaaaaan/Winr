import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/core/appmodels/winrate_records.dart';
import 'package:winr/feature/history/data/records_database.dart';

final desiredWinRateProvider = StateProvider<String>((ref) => "");
final numberOfBattlesProvider = StateProvider<String>((ref) => "");
final winRateProvider = StateProvider<String>((ref) => "");
final nameProvider = StateProvider<String>((ref) => "");

final requiredWinsMessageProvider = StateProvider<String?>((ref) {
  return ref.watch(requiredWinsProvider);
});

final requiredWinsProvider = Provider<String?>((ref) {
  final desiredWinRate =
      double.tryParse(ref.watch(desiredWinRateProvider)) ?? 0;
  final numberOfBattles = int.tryParse(ref.watch(numberOfBattlesProvider)) ?? 0;
  final winRate = double.tryParse(ref.watch(winRateProvider)) ?? 0;

  if (desiredWinRate <= 0 || desiredWinRate >= 100 || numberOfBattles <= 0) {
    return null;
  }

  final currentWins = ((winRate * numberOfBattles) / 100).round();

  final numerator = desiredWinRate * numberOfBattles - 100 * currentWins;
  final denominator = 100 - desiredWinRate;

  if (denominator <= 0) {
    return null;
  }

  final requiredWins = (numerator / denominator).ceil();

  if (requiredWins <= 0) {
    return null;
  }

  final totalBattles = numberOfBattles + requiredWins;
  final newWinRate = ((currentWins + requiredWins) / totalBattles * 100)
      .toStringAsFixed(2);

  return "You need to win $requiredWins consecutive battles "
      "to reach about $newWinRate% winrate.";
});

final recordsStreamProvider = StreamProvider.autoDispose<List<WinRateRecords>>((
  ref,
) {
  final db = RecordDatabase();

  ref.onDispose(() => db.dispose());

  return db.recordsStream;
});
