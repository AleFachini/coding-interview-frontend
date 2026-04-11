import 'dart:convert';
import 'dart:io';

import 'package:coding_interview_frontend/features/conversion/data/models/conversion_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {  test('fromJson reads byPrice rate', () {
    final model = ConversionResponseModel.fromJson(<String, dynamic>{
      'data': <String, dynamic>{
        'byPrice': <String, dynamic>{
          'fiatToCryptoExchangeRate': '5.1',
        },
      },
    });
    expect(model.fiatToCryptoExchangeRate, 5.1);
  });

  test('fromJson falls back to bySpeed when byPrice is null', () {
    final model = ConversionResponseModel.fromJson(<String, dynamic>{
      'data': <String, dynamic>{
        'byPrice': null,
        'bySpeed': <String, dynamic>{
          'fiatToCryptoExchangeRate': '4.2',
        },
      },
    });
    expect(model.fiatToCryptoExchangeRate, 4.2);
  });

  test('fromJson throws when data is missing', () {
    expect(
      () => ConversionResponseModel.fromJson(<String, dynamic>{}),
      throwsFormatException,
    );
  });

  test(
    'fromJson parses raw docs sample recommendations-type0.response.json',
    () {
      final File file = File('docs/samples/recommendations-type0.response.json');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'Run tests from package root; sample is versioned at $file',
      );
      final Map<String, dynamic> root = Map<String, dynamic>.from(
        json.decode(file.readAsStringSync()) as Map<dynamic, dynamic>,
      );
      final model = ConversionResponseModel.fromJson(root);
      expect(model.fiatToCryptoExchangeRate, 5.1);
    },
  );
}
