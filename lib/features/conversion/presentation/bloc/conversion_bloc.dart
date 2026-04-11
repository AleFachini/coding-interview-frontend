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
            sourceCurrency: CurrencyCatalog.usdtTron,
            fiatCurrency: CurrencyCatalog.fiatByCode('BRL'),
            amountCurrency: CurrencyCatalog.fiatByCode('BRL'),
            amountText: '100',
          ),
        ) {
    on<ConversionAppStarted>(_onAppStarted);
    on<SourceCurrencyChanged>(_onSourceChanged);
    on<FiatCurrencyChanged>(_onFiatCurrencyChanged);
    on<AmountChanged>(_onAmountChanged);
    on<ConvertRequested>(_onConvertRequested);
  }

  final GetConversionQuoteUseCase _getConversionQuoteUseCase;

  void _onAppStarted(
    ConversionAppStarted event,
    Emitter<ConversionState> emit,
  ) {
    add(const ConvertRequested());
  }

  void _onSourceChanged(
    SourceCurrencyChanged event,
    Emitter<ConversionState> emit,
  ) {
    emit(
      state.copyWith(
        sourceCurrency: event.currency,
        amountCurrency: event.currency,
        clearError: true,
        clearQuote: true,
      ),
    );
  }

  void _onFiatCurrencyChanged(
    FiatCurrencyChanged event,
    Emitter<ConversionState> emit,
  ) {
    emit(
      state.copyWith(
        fiatCurrency: event.currency,
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
    final num? amount = num.tryParse(state.amountText);
    if (amount == null || amount <= 0) {
      emit(
        state.copyWith(
          errorMessage: 'Enter a valid amount greater than zero.',
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
          fiatCurrencyId: state.fiatCurrency.id,
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
