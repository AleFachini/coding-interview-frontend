import 'package:coding_interview_frontend/core/errors/api_exception.dart';
import 'package:coding_interview_frontend/features/conversion/data/datasources/conversion_remote_datasource.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/failures/conversion_failure.dart';
import 'package:coding_interview_frontend/features/conversion/domain/repositories/conversion_repository.dart';

class ConversionRepositoryImpl implements ConversionRepository {
  const ConversionRepositoryImpl(this._remoteDataSource);

  final ConversionRemoteDataSource _remoteDataSource;

  @override
  Future<ConversionQuote> getConversionQuote({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required num amount,
    required String amountCurrencyId,
  }) async {
    try {
      final response = await _remoteDataSource.getConversion(
        type: type,
        cryptoCurrencyId: cryptoCurrencyId,
        fiatCurrencyId: fiatCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );

      final double convertedAmount = type == 1
          ? amount.toDouble() * response.fiatToCryptoExchangeRate
          : amount.toDouble() / response.fiatToCryptoExchangeRate;

      return ConversionQuote(
        rate: response.fiatToCryptoExchangeRate,
        convertedAmount: convertedAmount,
      );
    } on ApiException catch (error) {
      throw ConversionFailure(error.message);
    }
  }
}
