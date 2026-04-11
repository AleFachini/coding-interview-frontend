import 'package:equatable/equatable.dart';

class ConversionFailure extends Equatable implements Exception {
  const ConversionFailure(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
