import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winr/feature/home/presentation/screen/homescreen.dart';

void main() {
  testWidgets(
    'HomeScreen: decimals accept positive decimals & integer accepts positive integers',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      final desiredFinder = find.byKey(const Key('desiredWinRate'));
      final battlesFinder = find.byKey(const Key('numberOfBattles'));
      final winRateFinder = find.byKey(const Key('winRate'));

      // decimal1 valid
      await tester.enterText(desiredFinder, '12.5');
      await tester.pump();
      expect(
        (tester.widget(desiredFinder) as TextField).controller!.text,
        '12.5',
      );

      // decimal1 invalid -> stays "12.5"
      await tester.enterText(desiredFinder, '-3.2');
      await tester.pump();
      expect(
        (tester.widget(desiredFinder) as TextField).controller!.text,
        '12.5',
      );

      // integer valid
      await tester.enterText(battlesFinder, '42');
      await tester.pump();
      expect(
        (tester.widget(battlesFinder) as TextField).controller!.text,
        '42',
      );

      // integer invalid (decimal) -> stays "42"
      await tester.enterText(battlesFinder, '3.14');
      await tester.pump();
      expect(
        (tester.widget(battlesFinder) as TextField).controller!.text,
        '42',
      );

      // decimal2 valid
      await tester.enterText(winRateFinder, '0.99');
      await tester.pump();
      expect(
        (tester.widget(winRateFinder) as TextField).controller!.text,
        '0.99',
      );

      // decimal2 invalid (letters) -> remains '0.99'
      await tester.enterText(winRateFinder, 'abc');
      await tester.pump();
      expect(
        (tester.widget(winRateFinder) as TextField).controller!.text,
        '0.99',
      );
    },
  );
}
