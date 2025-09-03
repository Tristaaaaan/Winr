import 'package:flutter_riverpod/flutter_riverpod.dart';

final desiredWinRateProvider = StateProvider<String>((ref) => "");
final numberOfBattlesProvider = StateProvider<String>((ref) => "");
final winRateProvider = StateProvider<String>((ref) => "");

final requiredWinsProvider = Provider<String>((ref) {
  final desiredWinRate =
      double.tryParse(ref.watch(desiredWinRateProvider)) ?? 0;
  final numberOfBattles = int.tryParse(ref.watch(numberOfBattlesProvider)) ?? 0;
  final winRate = double.tryParse(ref.watch(winRateProvider)) ?? 0;

  if (desiredWinRate <= 0 || desiredWinRate >= 100 || numberOfBattles <= 0) {
    return "Please enter valid values (0–100% winrate, battles > 0).";
  }

  // Use rounded integer wins, not raw decimal
  final currentWins = ((winRate * numberOfBattles) / 100).round();

  final numerator = desiredWinRate * numberOfBattles - 100 * currentWins;
  final denominator = 100 - desiredWinRate;

  if (denominator <= 0) {
    return "Desired winrate must be less than 100%.";
  }

  final requiredWins = (numerator / denominator).ceil();

  if (requiredWins <= 0) {
    return "You already meet or exceed your desired winrate!";
  }

  final totalBattles = numberOfBattles + requiredWins;
  final newWinRate = ((currentWins + requiredWins) / totalBattles * 100)
      .toStringAsFixed(2);

  return "You need to win $requiredWins consecutive battles "
      "to reach about $newWinRate% winrate.";
});
