import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:equatable/equatable.dart';

class ConversionState extends Equatable {
  const ConversionState({
    required this.leftCurrency,
    required this.rightCurrency,
    required this.amountCurrency,
    required this.amountText,
    this.quote,
    this.errorMessage,
    this.isLoading = false,
  });

  /// TENGO (left chip): crypto or fiat depending on user flow.
  final Currency leftCurrency;

  /// QUIERO (right chip): the opposite side type from [leftCurrency].
  final Currency rightCurrency;

  /// Currency the [amountText] is denominated in (`amountCurrencyId` in API).
  final Currency amountCurrency;

  final String amountText;
  final ConversionQuote? quote;
  final String? errorMessage;
  final bool isLoading;

  /// API `type`: 0 = CRYPTO → FIAT, 1 = FIAT → CRYPTO.
  int get requestType =>
      leftCurrency.type == CurrencyType.crypto ? 0 : 1;

  Currency get cryptoSide =>
      leftCurrency.type == CurrencyType.crypto ? leftCurrency : rightCurrency;

  Currency get fiatSide =>
      leftCurrency.type == CurrencyType.fiat ? leftCurrency : rightCurrency;

  ConversionState copyWith({
    Currency? leftCurrency,
    Currency? rightCurrency,
    Currency? amountCurrency,
    String? amountText,
    ConversionQuote? quote,
    bool clearQuote = false,
    String? errorMessage,
    bool clearError = false,
    bool? isLoading,
  }) {
    return ConversionState(
      leftCurrency: leftCurrency ?? this.leftCurrency,
      rightCurrency: rightCurrency ?? this.rightCurrency,
      amountCurrency: amountCurrency ?? this.amountCurrency,
      amountText: amountText ?? this.amountText,
      quote: clearQuote ? null : (quote ?? this.quote),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        leftCurrency,
        rightCurrency,
        amountCurrency,
        amountText,
        quote,
        errorMessage,
        isLoading,
      ];
}
