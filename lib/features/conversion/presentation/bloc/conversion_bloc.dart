import 'package:bloc/bloc.dart';
import 'package:coding_interview_frontend/core/utils/currency_catalog.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/conversion_quote.dart';
import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:coding_interview_frontend/features/conversion/domain/failures/conversion_failure.dart';
import 'package:coding_interview_frontend/features/conversion/domain/usecases/get_conversion_quote_usecase.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_event.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_state.dart';

class ConversionBloc extends Bloc<ConversionEvent, ConversionState> {
  ConversionBloc(this._getConversionQuoteUseCase)
      : super(
          ConversionState(
            leftCurrency: CurrencyCatalog.usdtTron,
            rightCurrency: CurrencyCatalog.fiat.first,
            amountCurrency: CurrencyCatalog.usdtTron,
            amountText: '5',
          ),
        ) {
    on<LeftCurrencyChanged>(_onLeftCurrencyChanged);
    on<RightCurrencyChanged>(_onRightCurrencyChanged);
    on<SwapCurrenciesRequested>(_onSwapRequested);
    on<AmountChanged>(_onAmountChanged);
    on<ConvertRequested>(_onConvertRequested);
  }

  final GetConversionQuoteUseCase _getConversionQuoteUseCase;
  static const int _fixedRequestType = 0;

  void _onLeftCurrencyChanged(
    LeftCurrencyChanged event,
    Emitter<ConversionState> emit,
  ) {
    emit(
      state.copyWith(
        leftCurrency: event.currency,
        amountCurrency: event.currency,
        clearError: true,
        clearQuote: true,
      ),
    );
  }

  void _onRightCurrencyChanged(
    RightCurrencyChanged event,
    Emitter<ConversionState> emit,
  ) {
    emit(
      state.copyWith(
        rightCurrency: event.currency,
        clearError: true,
        clearQuote: true,
      ),
    );
  }

  void _onSwapRequested(
    SwapCurrenciesRequested event,
    Emitter<ConversionState> emit,
  ) {
    final num? amount = num.tryParse(state.amountText.replaceAll(',', '.'));
    final bool canInvertExistingQuote = state.quote != null &&
        state.quote!.rate > 0 &&
        amount != null &&
        amount > 0;

    final double? swappedRate = canInvertExistingQuote ? state.quote!.rate : null;
    final double? swappedConvertedAmount = canInvertExistingQuote
        ? _computeConvertedAmount(
            amount: state.quote!.convertedAmount,
            rate: state.quote!.rate,
            isCryptoToFiat: state.rightCurrency.type == CurrencyType.crypto,
          )
        : null;
    final String? swappedAmountText = canInvertExistingQuote
        ? state.quote!.convertedAmount.toStringAsFixed(2)
        : null;

    emit(
      state.copyWith(
        leftCurrency: state.rightCurrency,
        rightCurrency: state.leftCurrency,
        amountCurrency: state.rightCurrency,
        amountText: swappedAmountText,
        quote: canInvertExistingQuote
            ? ConversionQuote(
                rate: swappedRate!,
                convertedAmount: swappedConvertedAmount!,
              )
            : null,
        clearError: true,
        clearQuote: !canInvertExistingQuote,
      ),
    );
  }

  void _onAmountChanged(AmountChanged event, Emitter<ConversionState> emit) {
    emit(
      state.copyWith(
        amountText: event.amount,
        clearError: true,
        clearQuote: true,
      ),
    );
  }

  Future<void> _onConvertRequested(
    ConvertRequested event,
    Emitter<ConversionState> emit,
  ) async {
    final num? amount = num.tryParse(state.amountText.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      emit(
        state.copyWith(
          errorMessage: 'Ingresa un monto válido mayor a cero.',
          clearQuote: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final quote = await _getConversionQuoteUseCase(
        _buildFixedQueryParams(amount: amount),
      );
      final double? convertedAmount = _computeConvertedAmount(
        amount: amount.toDouble(),
        rate: quote.rate,
        isCryptoToFiat: state.leftCurrency.type == CurrencyType.crypto,
      );
      if (convertedAmount == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No se pudo calcular la conversión con la tasa actual.',
            clearQuote: true,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          isLoading: false,
          quote: ConversionQuote(
            rate: quote.rate,
            convertedAmount: convertedAmount,
          ),
          clearError: true,
        ),
      );
    } on ConversionFailure catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.message,
          clearQuote: true,
        ),
      );
    }
  }

  GetConversionQuoteParams _buildFixedQueryParams({required num amount}) {
    return GetConversionQuoteParams(
      type: _fixedRequestType,
      cryptoCurrencyId: CurrencyCatalog.usdtTron.id,
      fiatCurrencyId: state.fiatSide.id,
      amount: amount,
      amountCurrencyId: state.amountCurrency.id,
    );
  }

  double? _computeConvertedAmount({
    required double amount,
    required double rate,
    required bool isCryptoToFiat,
  }) {
    if (rate <= 0) {
      return null;
    }
    return isCryptoToFiat ? amount * rate : amount / rate;
  }
}
