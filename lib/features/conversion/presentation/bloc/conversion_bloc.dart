import 'package:bloc/bloc.dart';
import 'package:coding_interview_frontend/core/utils/currency_catalog.dart';
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
    emit(
      state.copyWith(
        leftCurrency: state.rightCurrency,
        rightCurrency: state.leftCurrency,
        amountCurrency: state.rightCurrency,
        clearError: true,
        clearQuote: true,
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
        GetConversionQuoteParams(
          type: state.requestType,
          cryptoCurrencyId: CurrencyCatalog.usdtTron.id,
          fiatCurrencyId: state.fiatSide.id,
          amount: amount,
          amountCurrencyId: state.amountCurrency.id,
        ),
      );
      emit(state.copyWith(isLoading: false, quote: quote, clearError: true));
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
}
