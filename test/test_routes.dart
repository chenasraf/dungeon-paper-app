import 'package:dungeon_paper/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Routes', () {
    test('All routes have paths', () {
      for (final route in Routes.values) {
        expect(route.path, isNotEmpty);
      }
    });
    test('All routes have analytics names', () {
      for (final route in Routes.values) {
        expect(route.analyticsName, isNotEmpty);
      }
    });
  });
}
