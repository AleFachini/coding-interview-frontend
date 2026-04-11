import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:equatable/equatable.dart';

sealed class ConversionEvent extends Equatable {
  const ConversionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class LeftCurrencyChanged extends ConversionEvent {
  const LeftCurrencyChanged(this.currency);

  final Currency currency;

  @override
  List<Object> get props => <Object>[currency];
}

final class RightCurrencyChanged extends ConversionEvent {
  const RightCurrencyChanged(this.currency);

  final Currency currency;

  @override
  List<Object> get props => <Object>[currency];
}

final class SwapCurrenciesRequested extends ConversionEvent {
  const SwapCurrenciesRequested();
}

final class AmountChanged extends ConversionEvent {
  const AmountChanged(this.amount);

  final String amount;

  @override
  List<Object> get props => <Object>[amount];
}

final class ConvertRequested extends ConversionEvent {
  const ConvertRequested();
}
