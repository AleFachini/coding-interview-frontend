import 'package:coding_interview_frontend/features/conversion/domain/entities/currency.dart';

/// Spanish subtitles for bottom-sheet rows (presentation only).
abstract final class CurrencySheetSubtitles {
  static String forCurrency(Currency currency) {
    switch (currency.code) {
      case 'VES':
        return 'Bolívares (Bs)';
      case 'COP':
        return r'Pesos Colombianos (COL$)';
      case 'PEN':
        return 'Soles Peruanos (S/)';
      case 'BRL':
        return r'Real Brasileño (R$)';
      case 'USDT':
        return 'Tether (USDT)';
      default:
        return currency.name;
    }
  }
}
