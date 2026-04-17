import 'package:bloc_test/bloc_test.dart';
import 'package:coding_interview_frontend/core/utils/currency_catalog.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/usecases/get_conversion_quote_usecase.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_bloc.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_event.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetConversionQuoteUseCase extends Mock
    implements GetConversionQuoteUseCase {}

class _FakeGetConversionQuoteParams extends Fake
    implements GetConversionQuoteParams {}

void main() {
  late GetConversionQuoteUseCase useCase;

  setUpAll(() {
    registerFallbackValue(_FakeGetConversionQuoteParams());
  });

  setUp(() {
    useCase = _MockGetConversionQuoteUseCase();
  });

  blocTest<ConversionBloc, ConversionState>(
    'emits error when amount is invalid',
    build: () => ConversionBloc(useCase),
    act: (ConversionBloc bloc) {
      bloc
        ..add(const AmountChanged('abc'))
        ..add(const ConvertRequested());
    },
    expect: () => <Matcher>[
      isA<ConversionState>().having((s) => s.amountText, 'amount', 'abc'),
      isA<ConversionState>().having(
        (s) => s.errorMessage,
        'error',
        'Ingresa un monto válido mayor a cero.',
      ),
    ],
  );

  blocTest<ConversionBloc, ConversionState>(
    'swap swaps left and right and moves amount currency to new left',
    build: () => ConversionBloc(useCase),
    act: (ConversionBloc bloc) => bloc.add(const SwapCurrenciesRequested()),
    expect: () => <Matcher>[
      isA<ConversionState>()
          .having((s) => s.leftCurrency.code, 'left', 'VES')
          .having((s) => s.rightCurrency.code, 'right', 'USDT')
          .having((s) => s.amountCurrency.code, 'amountCurrency', 'VES'),
    ],
  );

  blocTest<ConversionBloc, ConversionState>(
    'swap keeps same rate and recalculates converted amount direction',
    build: () {
      when(() => useCase(any())).thenAnswer(
        (_) async => const ConversionQuote(rate: 2, convertedAmount: 0),
      );
      return ConversionBloc(useCase);
    },
    act: (ConversionBloc bloc) async {
      bloc
        ..add(const AmountChanged('5'))
        ..add(const ConvertRequested());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SwapCurrenciesRequested());
    },
    expect: () => <Matcher>[
      isA<ConversionState>().having((s) => s.amountText, 'amount', '5'),
      isA<ConversionState>().having((s) => s.isLoading, 'isLoading', true),
      isA<ConversionState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.quote?.rate, 'quote.rate', 2.0)
          .having((s) => s.quote?.convertedAmount, 'quote.convertedAmount', 10),
      isA<ConversionState>()
          .having((s) => s.leftCurrency.code, 'left', 'VES')
          .having((s) => s.rightCurrency.code, 'right', 'USDT')
          .having((s) => s.amountCurrency.code, 'amountCurrency', 'VES')
          .having((s) => s.amountText, 'amountText', '10.00')
          .having((s) => s.quote?.rate, 'quote.rate', 2.0)
          .having((s) => s.quote?.convertedAmount, 'quote.convertedAmount', 5.0),
    ],
  );

  blocTest<ConversionBloc, ConversionState>(
    'emits loading then quote with multiplied amount in crypto to fiat',
    build: () {
      when(() => useCase(any())).thenAnswer(
        (_) async => const ConversionQuote(rate: 2, convertedAmount: 0),
      );
      return ConversionBloc(useCase);
    },
    act: (ConversionBloc bloc) => bloc.add(const ConvertRequested()),
    expect: () => <Matcher>[
      isA<ConversionState>().having((s) => s.isLoading, 'isLoading', true),
      isA<ConversionState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.quote?.rate, 'rate', 2.0)
          .having((s) => s.quote?.convertedAmount, 'convertedAmount', 10.0),
    ],
    verify: (_) {
      final VerificationResult verification = verify(() => useCase(captureAny()));
      final params = verification.captured.single as GetConversionQuoteParams;
      expect(params.type, 0);
      expect(params.amountCurrencyId, CurrencyCatalog.usdtTron.id);
    },
  );

  blocTest<ConversionBloc, ConversionState>(
    'emits divided amount in fiat to crypto with fixed query type',
    build: () {
      when(() => useCase(any())).thenAnswer(
        (_) async => const ConversionQuote(rate: 2, convertedAmount: 0),
      );
      return ConversionBloc(useCase);
    },
    act: (ConversionBloc bloc) {
      bloc
        ..add(const SwapCurrenciesRequested())
        ..add(const AmountChanged('10'))
        ..add(const ConvertRequested());
    },
    expect: () => <Matcher>[
      isA<ConversionState>()
          .having((s) => s.leftCurrency.code, 'left', 'VES')
          .having((s) => s.rightCurrency.code, 'right', 'USDT')
          .having((s) => s.amountCurrency.code, 'amountCurrency', 'VES'),
      isA<ConversionState>().having((s) => s.amountText, 'amount', '10'),
      isA<ConversionState>().having((s) => s.isLoading, 'isLoading', true),
      isA<ConversionState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.quote?.rate, 'rate', 2.0)
          .having((s) => s.quote?.convertedAmount, 'convertedAmount', 5.0),
    ],
    verify: (_) {
      final VerificationResult verification = verify(() => useCase(captureAny()));
      final params = verification.captured.single as GetConversionQuoteParams;
      expect(params.type, 0);
      expect(params.amountCurrencyId, CurrencyCatalog.fiat.first.id);
    },
  );

  blocTest<ConversionBloc, ConversionState>(
    'emits controlled error when rate is invalid',
    build: () {
      when(() => useCase(any())).thenAnswer(
        (_) async => const ConversionQuote(rate: 0, convertedAmount: 0),
      );
      return ConversionBloc(useCase);
    },
    act: (ConversionBloc bloc) => bloc.add(const ConvertRequested()),
    expect: () => <Matcher>[
      isA<ConversionState>().having((s) => s.isLoading, 'isLoading', true),
      isA<ConversionState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having(
            (s) => s.errorMessage,
            'error',
            'No se pudo calcular la conversión con la tasa actual.',
          )
          .having((s) => s.quote, 'quote', isNull),
    ],
  );
}
