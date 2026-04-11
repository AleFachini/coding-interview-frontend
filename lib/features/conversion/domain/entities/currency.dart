import 'package:equatable/equatable.dart';

enum CurrencyType { fiat, crypto }

class Currency extends Equatable {
  const Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.assetPath,
  });

  /// API currency id from the asset file name (without extension), e.g. `BRL`,
  /// `TATUM-TRON-USDT`.
  final String id;
  final String code;
  final String name;
  final CurrencyType type;
  final String assetPath;

  @override
  List<Object> get props => <Object>[id, code, name, type, assetPath];
}
