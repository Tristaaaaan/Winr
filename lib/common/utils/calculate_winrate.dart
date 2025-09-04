// Helper to calculate needed consecutive wins

int calculateNeededWins({
  required int desiredWinRate,
  required int currentNumberOfBattles,
  required int currentWinRate,
}) {
  if (desiredWinRate <= 0 ||
      desiredWinRate >= 100 ||
      currentNumberOfBattles <= 0) {
    return 0; // invalid input
  }

  final currentWins = ((currentWinRate * currentNumberOfBattles) / 100).round();

  final numerator = desiredWinRate * currentNumberOfBattles - 100 * currentWins;
  final denominator = 100 - desiredWinRate;

  if (denominator <= 0) return 0;

  final requiredWins = (numerator / denominator).ceil();

  return requiredWins > 0 ? requiredWins : 0;
}
