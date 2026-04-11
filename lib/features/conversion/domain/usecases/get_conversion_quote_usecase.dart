import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/repositories/conversion_repository.dart';
import 'package:equatable/equatable.dart';

class GetConversionQuoteUseCase {
  const GetConversionQuoteUseCase(this._repository);

  final ConversionRepository _repository;

  Future<ConversionQuote> call(GetConversionQuoteParams params) {
    return _repository.getConversionQuote(
      type: params.type,
      cryptoCurrencyId: params.cryptoCurrencyId,
      fiatCurrencyId: params.fiatCurrencyId,
      amount: params.amount,
      amountCurrencyId: params.amountCurrencyId,
    );
  }
}

class GetConversionQuoteParams extends Equatable {
  const GetConversionQuoteParams({
    required this.type,
    required this.cryptoCurrencyId,
    required this.fiatCurrencyId,
    required this.amount,
    required this.amountCurrencyId,
  });

  final int type;
  final String cryptoCurrencyId;
  final String fiatCurrencyId;
  final num amount;
  final String amountCurrencyId;

  @override
  List<Object> get props => <Object>[
        type,
        cryptoCurrencyId,
        fiatCurrencyId,
        amount,
        amountCurrencyId,
      ];
}
