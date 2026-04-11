import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';

abstract class ConversionRepository {
  Future<ConversionQuote> getConversionQuote({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required num amount,
    required String amountCurrencyId,
  });
}
