import 'package:flutter_test/flutter_test.dart';
import 'package:walled_demo_app/core/utils/validators.dart';

void main() {
  group('transfer validation', () {
    test('rejects empty, zero and negative amounts', () {
      expect(amountValidator(null), isNotNull);
      expect(amountValidator('0'), isNotNull);
      expect(amountValidator('-1'), isNotNull);
    });
    test(
      'accepts a positive amount',
      () => expect(amountValidator('125.50'), isNull),
    );
  });
}
