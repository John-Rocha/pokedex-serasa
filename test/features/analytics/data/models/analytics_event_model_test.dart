import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/analytics/data/models/analytics_event_model.dart';
import 'package:pokedex_serasa/features/analytics/domain/entities/analytics_event.dart';

void main() {
  group('AnalyticsEventModel Tests', () {
    final timestamp = DateTime(2024, 1, 1, 12, 0, 0);
    final tParameters = {'key': 'value', 'count': 42};

    final tAnalyticsEventModel = AnalyticsEventModel(
      name: 'test_event',
      parameters: tParameters,
      timestamp: timestamp,
    );

    test('should be a subclass of AnalyticsEvent', () {
      expect(tAnalyticsEventModel, isA<AnalyticsEvent>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final json = {
          'name': 'test_event',
          'parameters': {'key': 'value', 'count': 42},
          'timestamp': '2024-01-01T12:00:00.000',
        };

        final result = AnalyticsEventModel.fromJson(json);

        expect(result.name, 'test_event');
        expect(result.parameters['key'], 'value');
        expect(result.parameters['count'], 42);
        expect(result.timestamp, DateTime(2024, 1, 1, 12, 0, 0));
      });

      test('should handle empty parameters from JSON', () {
        final json = {
          'name': 'empty_event',
          'parameters': {},
          'timestamp': '2024-01-01T12:00:00.000',
        };

        final result = AnalyticsEventModel.fromJson(json);

        expect(result.name, 'empty_event');
        expect(result.parameters, {});
      });

      test('should handle complex parameters from JSON', () {
        final json = {
          'name': 'complex_event',
          'parameters': {
            'string': 'value',
            'int': 42,
            'double': 3.14,
            'bool': true,
            'list': [1, 2, 3],
            'nested': {'key': 'value'},
          },
          'timestamp': '2024-01-01T12:00:00.000',
        };

        final result = AnalyticsEventModel.fromJson(json);

        expect(result.parameters['string'], 'value');
        expect(result.parameters['int'], 42);
        expect(result.parameters['double'], 3.14);
        expect(result.parameters['bool'], true);
        expect(result.parameters['list'], [1, 2, 3]);
        expect(result.parameters['nested'], {'key': 'value'});
      });
    });

    group('toJson', () {
      test('should return a JSON map with proper data', () {
        final result = tAnalyticsEventModel.toJson();

        expect(result, {
          'name': 'test_event',
          'parameters': tParameters,
          'timestamp': '2024-01-01T12:00:00.000',
        });
      });

      test('should handle empty parameters in toJson', () {
        final model = AnalyticsEventModel(
          name: 'empty_event',
          parameters: {},
          timestamp: timestamp,
        );

        final result = model.toJson();

        expect(result['parameters'], {});
      });
    });

    group('fromEntity', () {
      test('should create a model from an entity', () {
        final entity = AnalyticsEvent(
          name: 'entity_event',
          parameters: {'param': 'value'},
          timestamp: timestamp,
        );

        final result = AnalyticsEventModel.fromEntity(entity);

        expect(result.name, entity.name);
        expect(result.parameters, entity.parameters);
        expect(result.timestamp, entity.timestamp);
        expect(result, isA<AnalyticsEventModel>());
      });
    });

    group('toMethodChannelMap', () {
      test('should return a map formatted for MethodChannel', () {
        final result = tAnalyticsEventModel.toMethodChannelMap();

        expect(result['eventName'], 'test_event');
        expect(result['parameters'], isA<Map<String, dynamic>>());
        expect(result['parameters']['key'], 'value');
        expect(result['parameters']['count'], 42);
        expect(
          result['parameters']['timestamp'],
          '2024-01-01T12:00:00.000',
        );
      });

      test('should include timestamp in parameters for MethodChannel', () {
        final result = tAnalyticsEventModel.toMethodChannelMap();

        expect(result['parameters']['timestamp'], isNotNull);
        expect(result['parameters']['timestamp'], isA<String>());
      });

      test('should use eventName key instead of name for MethodChannel', () {
        final result = tAnalyticsEventModel.toMethodChannelMap();

        expect(result.containsKey('eventName'), true);
        expect(result.containsKey('name'), false);
      });
    });

    group('JSON serialization round-trip', () {
      test('should maintain data integrity through toJson and fromJson', () {
        final json = tAnalyticsEventModel.toJson();
        final modelFromJson = AnalyticsEventModel.fromJson(json);

        expect(modelFromJson.name, tAnalyticsEventModel.name);
        expect(modelFromJson.parameters, tAnalyticsEventModel.parameters);
        expect(
          modelFromJson.timestamp.toIso8601String(),
          tAnalyticsEventModel.timestamp.toIso8601String(),
        );
      });
    });
  });
}
