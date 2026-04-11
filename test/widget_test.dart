import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/usecases/get_conversion_quote_usecase.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_bloc.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/pages/conversion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetConversionQuoteUseCase extends Mock
    implements GetConversionQuoteUseCase {}

class _FakeGetConversionQuoteParams extends Fake
    implements GetConversionQuoteParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeGetConversionQuoteParams());
  });

  testWidgets('conversion page shows Cambiar and TENGO labels', (
    WidgetTester tester,
  ) async {
    final GetConversionQuoteUseCase useCase = _MockGetConversionQuoteUseCase();
    when(() => useCase(any())).thenAnswer(
      (_) async => const ConversionQuote(rate: 1, convertedAmount: 1),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ConversionBloc>(
          create: (_) => ConversionBloc(useCase),
          child: const ConversionPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Cambiar'), findsOneWidget);
    expect(find.text('TENGO'), findsOneWidget);
    expect(find.text('QUIERO'), findsOneWidget);
  });
}
