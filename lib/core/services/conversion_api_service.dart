/// Service helpers for the public Conversion API.
///
/// This class centralizes how the endpoint URL is built so it can be reused by
/// any HTTP client implementation.
class ConversionApiService {
  /// Base endpoint for Conversion.
  static const String _baseUrl =
      'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations';

  /// Builds the full GET URL used to request a conversion quote.
  ///
  /// You can copy the returned URL and paste it directly in:
  /// - any browser address bar (GET request), or
  /// - Postman (method: GET).
  ///
  /// Query params:
  /// - [type]: `0` for CRYPTO -> FIAT, `1` for FIAT -> CRYPTO.
  /// - [cryptoCurrencyId]: crypto id from asset file name (e.g. `TATUM-TRON-USDT`).
  /// - [fiatCurrencyId]: fiat id from asset file name (e.g. `BRL`).
  /// - [amount]: amount to convert (as number text).
  /// - [amountCurrencyId]: id of the currency the amount is expressed in.
  ///
  /// Example full URL (ids match asset file names, without `.png`):
  /// `https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations?type=0&cryptoCurrencyId=TATUM-TRON-USDT&fiatCurrencyId=BRL&amount=100&amountCurrencyId=BRL`
  ///
  /// Manual check steps:
  /// 1. Build the URL using this method.
  /// 2. Paste the URL in browser/Postman.
  /// 3. Verify `data.byPrice.fiatToCryptoExchangeRate` in the response.
  Uri buildConversionUri({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required num amount,
    required String amountCurrencyId,
  }) {
    return Uri.parse(_baseUrl).replace(
      queryParameters: <String, String>{
        'type': type.toString(),
        'cryptoCurrencyId': cryptoCurrencyId,
        'fiatCurrencyId': fiatCurrencyId,
        'amount': amount.toString(),
        'amountCurrencyId': amountCurrencyId,
      },
    );
  }
}
