class ApiUserMessageMapper {
  const ApiUserMessageMapper._();

  static const String _vesCurrencyId = 'VES';
  static const String _vesUnavailableMessage = 'Exchange Rate Not Available';
  static const String _defaultConversionMessage =
      'Unable to retrieve exchange rate';

  static String conversionMessageFor({
    required String fiatCurrencyId,
  }) {
    if (fiatCurrencyId.toUpperCase() == _vesCurrencyId) {
      return _vesUnavailableMessage;
    }

    return _defaultConversionMessage;
  }
}
