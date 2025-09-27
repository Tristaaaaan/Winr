import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winr/common/components/textfield/form_textfield.dart';
import 'package:winr/common/utils/name_formatter.dart';
import 'package:winr/common/utils/winrate_input_formatter.dart';

void main() {
  testWidgets('FormTextFields update values when typing', (
    WidgetTester tester,
  ) async {
    String? name;
    String? battles;
    String? winRate;
    String? desiredWinRate;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              FormTextField(
                key: const ValueKey('name'),
                fieldKey: 'name',
                isText: true,
                inputFormatters: const [MaxLengthFormatter(maxLength: 50)],
                labelText: 'How about adding a name? (optional)',
                isUpdate: true,
                onChanged: (value) => name = value,
              ),
              FormTextField(
                key: const ValueKey('numberOfBattles'),
                fieldKey: 'numberOfBattles',
                labelText: 'What is your current number of battles?',
                isUpdate: true,
                inputFormatters: const [
                  WinrateInputFormatter(integersOnly: true, max: 1000000),
                ],
                onChanged: (value) => battles = value,
              ),
              FormTextField(
                key: const ValueKey('winRate'),
                fieldKey: 'winRate',
                showPercentSuffix: true,
                labelText: 'What is your current win rate? (in Percentage)',
                isUpdate: true,
                inputFormatters: const [
                  WinrateInputFormatter(integersOnly: false, max: 100),
                ],
                onChanged: (value) => winRate = value,
              ),
              FormTextField(
                key: const ValueKey('desiredWinRate'),
                fieldKey: 'desiredWinRate',
                showPercentSuffix: true,
                inputFormatters: const [
                  WinrateInputFormatter(integersOnly: false, max: 100),
                ],
                labelText: 'What is your desired win rate? (in Percentage)',
                isUpdate: true,
                onChanged: (value) => desiredWinRate = value,
              ),
            ],
          ),
        ),
      ),
    );

    // 🔹 Name field
    await tester.enterText(find.byKey(const ValueKey('name')), 'Player1');
    expect(name, 'Player1');

    final longText = 'a' * 60;
    await tester.enterText(find.byKey(const ValueKey('name')), longText);
    expect(name!.length, 50);

    await tester.enterText(find.byKey(const ValueKey('name')), '');
    expect(name, '');

    // 🔹 Battles field (integers only, max 1,000,000)
    await tester.enterText(
      find.byKey(const ValueKey('numberOfBattles')),
      '150',
    );
    expect(battles, '150');

    await tester.enterText(
      find.byKey(const ValueKey('numberOfBattles')),
      '999999',
    );
    expect(battles, '999999');

    await tester.enterText(
      find.byKey(const ValueKey('numberOfBattles')),
      '1234567',
    );
    expect(battles, '999999'); // stays at last valid

    // 🔹 WinRate field (max 100, decimals up to 5)
    await tester.enterText(find.byKey(const ValueKey('winRate')), '75');
    expect(winRate, '75');

    await tester.enterText(find.byKey(const ValueKey('desiredWinRate')), '80');
    expect(desiredWinRate, '80');

    await tester.enterText(find.byKey(const ValueKey('winRate')), '55.12345');
    expect(winRate, '55.12345');

    await tester.enterText(find.byKey(const ValueKey('winRate')), '55.123456');
    expect(winRate, '55.12345'); // stays at last valid

    await tester.enterText(find.byKey(const ValueKey('desiredWinRate')), '-80');
    expect(desiredWinRate, '80');

    await tester.enterText(
      find.byKey(const ValueKey('desiredWinRate')),
      '120.5',
    );
    expect(desiredWinRate, '80');

    await tester.enterText(find.byKey(const ValueKey('winRate')), '100');
    expect(winRate, '100'); // valid, max allowed
  });
}
