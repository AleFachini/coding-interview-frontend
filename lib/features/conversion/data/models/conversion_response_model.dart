class ConversionResponseModel {
  const ConversionResponseModel({required this.fiatToCryptoExchangeRate});

  /// Parses `data.byPrice.fiatToCryptoExchangeRate`, then tries `bySpeed` and
  /// `byReputation` when `byPrice` is null or has no rate.
  ///
  /// A full real response body for manual checks and tests lives at
  /// `docs/samples/recommendations-type0.response.json`.
  factory ConversionResponseModel.fromJson(Map<String, dynamic> json) {
    final Object? rawData = json['data'];
    if (rawData is! Map) {
      throw const FormatException(
        'Missing or invalid "data" in API response',
      );
    }
    final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);

    final double? rate = _firstAvailableRate(data);
    if (rate == null) {
      throw const FormatException(
        'No fiatToCryptoExchangeRate under data.byPrice, bySpeed, or byReputation',
      );
    }
    return ConversionResponseModel(fiatToCryptoExchangeRate: rate);
  }

  static const List<String> _bucketKeys = <String>[
    'byPrice',
    'bySpeed',
    'byReputation',
  ];

  static double? _firstAvailableRate(Map<String, dynamic> data) {
    for (final String key in _bucketKeys) {
      final Object? bucket = data[key];
      if (bucket is! Map) {
        continue;
      }
      final Map<String, dynamic> offer = Map<String, dynamic>.from(bucket);
      final Object? rate = offer['fiatToCryptoExchangeRate'];
      if (rate == null) {
        continue;
      }
      final double? parsed = double.tryParse(rate.toString());
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }

  final double fiatToCryptoExchangeRate;
}
