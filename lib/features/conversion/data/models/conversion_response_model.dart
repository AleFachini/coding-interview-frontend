class ConversionResponseModel {
  const ConversionResponseModel({required this.fiatToCryptoExchangeRate});

  factory ConversionResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic rate = (json['data'] as Map<String, dynamic>)['byPrice']
        ['fiatToCryptoExchangeRate'];
    return ConversionResponseModel(
      fiatToCryptoExchangeRate: double.parse(rate.toString()),
    );
  }

  final double fiatToCryptoExchangeRate;
}
