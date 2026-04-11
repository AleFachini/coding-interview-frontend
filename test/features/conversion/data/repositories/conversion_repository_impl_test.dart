import 'package:coding_interview_frontend/core/errors/api_exception.dart';
import 'package:coding_interview_frontend/features/conversion/data/datasources/conversion_remote_datasource.dart';
import 'package:coding_interview_frontend/features/conversion/data/models/conversion_response_model.dart';
import 'package:coding_interview_frontend/features/conversion/data/repositories/conversion_repository_impl.dart';
import 'package:coding_interview_frontend/features/conversion/domain/failures/conversion_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConversionRemoteDataSource extends Mock
    implements ConversionRemoteDataSource {}

void main() {
  late ConversionRemoteDataSource dataSource;
  late ConversionRepositoryImpl repository;

  setUp(() {
    dataSource = _MockConversionRemoteDataSource();
    repository = ConversionRepositoryImpl(dataSource);
  });

  test('should multiply amount by rate when type is 1', () async {
    when(
      () => dataSource.getConversion(
        type: 1,
        cryptoCurrencyId: 'TATUM-TRON-USDT',
        fiatCurrencyId: 'BRL',
        amount: 100,
        amountCurrencyId: 'BRL',
      ),
    ).thenAnswer(
      (_) async => const ConversionResponseModel(fiatToCryptoExchangeRate: 2),
    );

    final result = await repository.getConversionQuote(
      type: 1,
      cryptoCurrencyId: 'TATUM-TRON-USDT',
      fiatCurrencyId: 'BRL',
      amount: 100,
      amountCurrencyId: 'BRL',
    );

    expect(result.convertedAmount, 200);
    expect(result.rate, 2);
  });

  test('should throw conversion failure when data source throws', () async {
    when(
      () => dataSource.getConversion(
        type: 1,
        cryptoCurrencyId: 'TATUM-TRON-USDT',
        fiatCurrencyId: 'BRL',
        amount: 100,
        amountCurrencyId: 'BRL',
      ),
    ).thenThrow(const ApiException('boom'));

    expect(
      () => repository.getConversionQuote(
        type: 1,
        cryptoCurrencyId: 'TATUM-TRON-USDT',
        fiatCurrencyId: 'BRL',
        amount: 100,
        amountCurrencyId: 'BRL',
      ),
      throwsA(isA<ConversionFailure>()),
    );
  });
}
