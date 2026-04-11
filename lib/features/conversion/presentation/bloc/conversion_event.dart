import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';
import 'package:equatable/equatable.dart';

sealed class ConversionEvent extends Equatable {
  const ConversionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class SourceCurrencyChanged extends ConversionEvent {
  const SourceCurrencyChanged(this.currency);

  final Currency currency;

  @override
  List<Object> get props => <Object>[currency];
}

final class FiatCurrencyChanged extends ConversionEvent {
  const FiatCurrencyChanged(this.currency);

  final Currency currency;

  @override
  List<Object> get props => <Object>[currency];
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

/// Dispatched once at startup to run the default conversion request.
final class ConversionAppStarted extends ConversionEvent {
  const ConversionAppStarted();
}
