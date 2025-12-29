import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/analytics/domain/entities/analytics_event.dart';

void main() {
  group('AnalyticsEvent Entity Tests', () {
    test('should create an AnalyticsEvent with required fields', () {
      final timestamp = DateTime(2024, 1, 1, 12, 0, 0);
      final parameters = {'key': 'value', 'count': 42};

      final event = AnalyticsEvent(
        name: 'test_event',
        parameters: parameters,
        timestamp: timestamp,
      );

      expect(event.name, 'test_event');
      expect(event.parameters, parameters);
      expect(event.timestamp, timestamp);
    });

    test('should create an AnalyticsEvent with empty parameters', () {
      final timestamp = DateTime(2024, 1, 1, 12, 0, 0);

      final event = AnalyticsEvent(
        name: 'empty_event',
        parameters: {},
        timestamp: timestamp,
      );

      expect(event.name, 'empty_event');
      expect(event.parameters, {});
      expect(event.timestamp, timestamp);
    });

    test('should create an AnalyticsEvent with complex parameters', () {
      final timestamp = DateTime(2024, 1, 1, 12, 0, 0);
      final parameters = {
        'string': 'value',
        'int': 42,
        'double': 3.14,
        'bool': true,
        'list': [1, 2, 3],
        'nested': {'key': 'value'},
      };

      final event = AnalyticsEvent(
        name: 'complex_event',
        parameters: parameters,
        timestamp: timestamp,
      );

      expect(event.name, 'complex_event');
      expect(event.parameters, parameters);
      expect(event.parameters['string'], 'value');
      expect(event.parameters['int'], 42);
      expect(event.parameters['double'], 3.14);
      expect(event.parameters['bool'], true);
      expect(event.parameters['list'], [1, 2, 3]);
      expect(event.parameters['nested'], {'key': 'value'});
    });

    test('should maintain timestamp precision', () {
      final timestamp = DateTime.now();

      final event = AnalyticsEvent(
        name: 'timestamp_test',
        parameters: {},
        timestamp: timestamp,
      );

      expect(event.timestamp, timestamp);
      expect(
        event.timestamp.millisecondsSinceEpoch,
        timestamp.millisecondsSinceEpoch,
      );
    });
  });
}
