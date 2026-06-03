import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/preview_support/preview_fixtures.dart';

void main() {
  test('fixtures return non-empty deterministic data', () {
    expect(sampleProducts(), isNotEmpty);
    expect(sampleCategories(), isNotEmpty);
    expect(sampleOrders(), isNotEmpty);
    expect(sampleOrder().items, isNotEmpty);
    expect(sampleUser().name, isNotEmpty);
    expect(sampleMeta()['role'], isNotNull);
  });
}
