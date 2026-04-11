import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:equatable/equatable.dart';

class ConversionState extends Equatable {
  const ConversionState({
    required this.sourceCurrency,
    required this.fiatCurrency,
    required this.amountCurrency,
    required this.amountText,
    this.quote,
    this.errorMessage,
    this.isLoading = false,
  });

  final Currency sourceCurrency;
  final Currency fiatCurrency;
  /// Currency the [amountText] is denominated in (maps to `amountCurrencyId`).
  final Currency amountCurrency;
  final String amountText;
  final ConversionQuote? quote;
  final String? errorMessage;
  final bool isLoading;

  int get requestType => sourceCurrency.type == CurrencyType.fiat ? 1 : 0;

  ConversionState copyWith({
    Currency? sourceCurrency,
    Currency? fiatCurrency,
    Currency? amountCurrency,
    String? amountText,
    ConversionQuote? quote,
    bool clearQuote = false,
    String? errorMessage,
    bool clearError = false,
    bool? isLoading,
  }) {
    return ConversionState(
      sourceCurrency: sourceCurrency ?? this.sourceCurrency,
      fiatCurrency: fiatCurrency ?? this.fiatCurrency,
      amountCurrency: amountCurrency ?? this.amountCurrency,
      amountText: amountText ?? this.amountText,
      quote: clearQuote ? null : (quote ?? this.quote),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        sourceCurrency,
        fiatCurrency,
        amountCurrency,
        amountText,
        quote,
        errorMessage,
        isLoading,
      ];
}
