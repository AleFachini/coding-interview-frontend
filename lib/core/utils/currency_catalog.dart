import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';

/// Static catalog used by the interview app.
///
/// [Currency.id] matches the public API: id from the asset file name (no `.png`).
abstract final class CurrencyCatalog {
  static const List<Currency> fiat = <Currency>[
    Currency(
      id: 'VES',
      code: 'VES',
      name: 'Bolivar',
      type: CurrencyType.fiat,
      assetPath: 'assets/fiat_currencies/VES.png',
    ),
    Currency(
      id: 'COP',
      code: 'COP',
      name: 'Colombian Peso',
      type: CurrencyType.fiat,
      assetPath: 'assets/fiat_currencies/COP.png',
    ),
    Currency(
      id: 'PEN',
      code: 'PEN',
      name: 'Sol',
      type: CurrencyType.fiat,
      assetPath: 'assets/fiat_currencies/PEN.png',
    ),
    Currency(
      id: 'BRL',
      code: 'BRL',
      name: 'Brazilian Real',
      type: CurrencyType.fiat,
      assetPath: 'assets/fiat_currencies/BRL.png',
    ),
  ];

  static const Currency usdtTron = Currency(
    id: 'TATUM-TRON-USDT',
    code: 'USDT',
    name: 'TATUM TRON USDT',
    type: CurrencyType.crypto,
    assetPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
  );

  static Currency fiatByCode(String code) {
    return fiat.firstWhere((Currency c) => c.code == code);
  }
}
