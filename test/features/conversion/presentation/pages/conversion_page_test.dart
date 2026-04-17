import 'package:coding_interview_frontend/features/conversion/domain/usecases/get_conversion_quote_usecase.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_bloc.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/pages/conversion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetConversionQuoteUseCase extends Mock
    implements GetConversionQuoteUseCase {}

void main() {
  testWidgets(
    'shows left (TENGO) currency code as amount prefix',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ConversionBloc>(
            create: (_) => ConversionBloc(_MockGetConversionQuoteUseCase()),
            child: const ConversionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('USDT '), findsOneWidget);
      expect(find.text('VES '), findsNothing);
    },
  );

  testWidgets(
    'updates amount prefix to new left currency after swap',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ConversionBloc>(
            create: (_) => ConversionBloc(_MockGetConversionQuoteUseCase()),
            child: const ConversionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('USDT '), findsOneWidget);

      await tester.tap(find.byKey(const Key('currency_swap_pill_swap')));
      await tester.pumpAndSettle();

      expect(find.text('VES '), findsOneWidget);
      expect(find.text('USDT '), findsNothing);
    },
  );
}
