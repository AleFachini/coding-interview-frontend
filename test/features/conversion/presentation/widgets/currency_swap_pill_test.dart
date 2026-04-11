import 'package:coding_interview_frontend/core/utils/currency_catalog.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/widgets/currency_swap_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CurrencySwapPill invokes callbacks', (WidgetTester tester) async {
    var leftTaps = 0;
    var rightTaps = 0;
    var swapTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CurrencySwapPill(
            leftCurrency: CurrencyCatalog.usdtTron,
            rightCurrency: CurrencyCatalog.fiat.first,
            onLeftTap: () => leftTaps++,
            onRightTap: () => rightTaps++,
            onSwap: () => swapTaps++,
          ),
        ),
      ),
    );

    expect(find.text('TENGO'), findsOneWidget);
    expect(find.text('QUIERO'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
    expect(find.text('VES'), findsOneWidget);

    await tester.tap(find.byKey(const Key('currency_swap_pill_left')));
    await tester.tap(find.byKey(const Key('currency_swap_pill_right')));
    await tester.tap(find.byKey(const Key('currency_swap_pill_swap')));

    expect(leftTaps, 1);
    expect(rightTaps, 1);
    expect(swapTaps, 1);
  });
}
