import 'package:equatable/equatable.dart';

class ConversionQuote extends Equatable {
  const ConversionQuote({
    required this.rate,
    required this.convertedAmount,
  });

  final double rate;
  final double convertedAmount;

  @override
  List<Object> get props => <Object>[rate, convertedAmount];
}
