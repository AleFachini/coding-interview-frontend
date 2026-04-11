import 'package:coding_interview_frontend/core/errors/api_exception.dart';
import 'package:coding_interview_frontend/core/services/conversion_api_service.dart';
import 'package:coding_interview_frontend/features/conversion/data/models/conversion_response_model.dart';
import 'package:dio/dio.dart';

abstract class ConversionRemoteDataSource {
  Future<ConversionResponseModel> getConversion({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required num amount,
    required String amountCurrencyId,
  });
}

class ConversionRemoteDataSourceImpl implements ConversionRemoteDataSource {
  const ConversionRemoteDataSourceImpl({
    required Dio dio,
    required ConversionApiService apiService,
  })  : _dio = dio,
        _apiService = apiService;

  final Dio _dio;
  final ConversionApiService _apiService;

  @override
  Future<ConversionResponseModel> getConversion({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required num amount,
    required String amountCurrencyId,
  }) async {
    try {
      final Uri uri = _apiService.buildConversionUri(
        type: type,
        cryptoCurrencyId: cryptoCurrencyId,
        fiatCurrencyId: fiatCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );
      final Response<Map<String, dynamic>> response =
          await _dio.getUri<Map<String, dynamic>>(uri);
      final Map<String, dynamic>? body = response.data;
      if (body == null) {
        throw const ApiException('Empty response body');
      }
      return ConversionResponseModel.fromJson(body);
    } on DioException catch (error) {
      throw ApiException(error.message ?? 'Network error');
    } on FormatException catch (error) {
      throw ApiException('Unexpected API response: ${error.message}');
    }
  }
}
