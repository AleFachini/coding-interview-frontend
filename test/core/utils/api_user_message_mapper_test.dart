import 'package:coding_interview_frontend/core/utils/api_user_message_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiUserMessageMapper.conversionMessageFor', () {
    test('returns VES specific message', () {
      final String message = ApiUserMessageMapper.conversionMessageFor(
        fiatCurrencyId: 'VES',
      );

      expect(message, 'Exchange Rate Not Available');
    });

    test('returns default conversion message for non VES currency', () {
      final String message = ApiUserMessageMapper.conversionMessageFor(
        fiatCurrencyId: 'BRL',
      );

      expect(message, 'Unable to retrieve exchange rate');
    });

    test('matches VES currency id case-insensitively', () {
      final String message = ApiUserMessageMapper.conversionMessageFor(
        fiatCurrencyId: 'ves',
      );

      expect(message, 'Exchange Rate Not Available');
    });
  });
}
