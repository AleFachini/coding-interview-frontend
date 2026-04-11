import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/repositories/conversion_repository.dart';
import 'package:coding_interview_frontend/features/conversion/domain/usecases/get_conversion_quote_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConversionRepository extends Mock implements ConversionRepository {}

void main() {
  late ConversionRepository repository;
  late GetConversionQuoteUseCase useCase;

  setUp(() {
    repository = _MockConversionRepository();
    useCase = GetConversionQuoteUseCase(repository);
  });

  test('should call repository with expected params', () async {
    const params = GetConversionQuoteParams(
      type: 1,
      cryptoCurrencyId: 'TATUM-TRON-USDT',
      fiatCurrencyId: 'BRL',
      amount: 100,
      amountCurrencyId: 'BRL',
    );
    const expected = ConversionQuote(rate: 0.9, convertedAmount: 90);
    when(
      () => repository.getConversionQuote(
        type: params.type,
        cryptoCurrencyId: params.cryptoCurrencyId,
        fiatCurrencyId: params.fiatCurrencyId,
        amount: params.amount,
        amountCurrencyId: params.amountCurrencyId,
      ),
    ).thenAnswer((_) async => expected);

    final result = await useCase(params);

    expect(result, expected);
    verify(
      () => repository.getConversionQuote(
        type: params.type,
        cryptoCurrencyId: params.cryptoCurrencyId,
        fiatCurrencyId: params.fiatCurrencyId,
        amount: params.amount,
        amountCurrencyId: params.amountCurrencyId,
      ),
    ).called(1);
  });
}
