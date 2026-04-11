import 'package:bloc_test/bloc_test.dart';
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
    'emits loading then quote when convert succeeds',
    build: () {
      when(() => useCase(any())).thenAnswer(
        (_) async => const ConversionQuote(rate: 2, convertedAmount: 200),
      );
      return ConversionBloc(useCase);
    },
    act: (ConversionBloc bloc) => bloc.add(const ConvertRequested()),
    expect: () => <Matcher>[
      isA<ConversionState>().having((s) => s.isLoading, 'isLoading', true),
      isA<ConversionState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.quote?.convertedAmount, 'convertedAmount', 200),
    ],
  );
}
