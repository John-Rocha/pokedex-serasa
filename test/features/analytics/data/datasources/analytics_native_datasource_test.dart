import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/core/platform/analytics_channel.dart';
import 'package:pokedex_serasa/features/analytics/data/datasources/analytics_native_datasource.dart';

class MockAnalyticsChannel extends Mock implements AnalyticsChannel {}

void main() {
  late AnalyticsNativeDataSource datasource;
  late MockAnalyticsChannel mockChannel;

  setUp(() {
    mockChannel = MockAnalyticsChannel();
    datasource = AnalyticsNativeDataSource(channel: mockChannel);
  });

  group('AnalyticsNativeDataSource', () {
    group('logEvent', () {
      const tEventName = 'test_event';
      final tParameters = {'key': 'value', 'count': 42};

      test('should call logEvent on channel with correct parameters', () async {
        when(
          () => mockChannel.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async => Future.value());

        await datasource.logEvent(
          eventName: tEventName,
          parameters: tParameters,
        );

        verify(
          () => mockChannel.logEvent(
            eventName: tEventName,
            parameters: tParameters,
          ),
        ).called(1);
      });

      test('should rethrow AnalyticsException from channel', () async {
        when(
          () => mockChannel.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenThrow(
          const AnalyticsException('Channel error'),
        );

        expect(
          () => datasource.logEvent(
            eventName: tEventName,
            parameters: tParameters,
          ),
          throwsA(isA<AnalyticsException>()),
        );

        verify(
          () => mockChannel.logEvent(
            eventName: tEventName,
            parameters: tParameters,
          ),
        ).called(1);
      });

      test('should wrap unexpected exceptions in AnalyticsException', () async {
        when(
          () => mockChannel.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => datasource.logEvent(
            eventName: tEventName,
            parameters: tParameters,
          ),
          throwsA(
            isA<AnalyticsException>().having(
              (e) => e.message,
              'message',
              'Erro inesperado ao logar evento',
            ),
          ),
        );

        verify(
          () => mockChannel.logEvent(
            eventName: tEventName,
            parameters: tParameters,
          ),
        ).called(1);
      });

      test('should handle empty parameters', () async {
        when(
          () => mockChannel.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async => Future.value());

        await datasource.logEvent(
          eventName: tEventName,
          parameters: {},
        );

        verify(
          () => mockChannel.logEvent(
            eventName: tEventName,
            parameters: {},
          ),
        ).called(1);
      });
    });

    group('logScreenView', () {
      const tScreenName = 'HomeScreen';
      const tScreenClass = 'HomePage';

      test(
        'should call logScreenView on channel with correct parameters',
        () async {
          when(
            () => mockChannel.logScreenView(
              screenName: any(named: 'screenName'),
              screenClass: any(named: 'screenClass'),
            ),
          ).thenAnswer((_) async => Future.value());

          await datasource.logScreenView(
            screenName: tScreenName,
            screenClass: tScreenClass,
          );

          verify(
            () => mockChannel.logScreenView(
              screenName: tScreenName,
              screenClass: tScreenClass,
            ),
          ).called(1);
        },
      );

      test('should rethrow AnalyticsException from channel', () async {
        when(
          () => mockChannel.logScreenView(
            screenName: any(named: 'screenName'),
            screenClass: any(named: 'screenClass'),
          ),
        ).thenThrow(
          const AnalyticsException('Channel error'),
        );

        expect(
          () => datasource.logScreenView(
            screenName: tScreenName,
            screenClass: tScreenClass,
          ),
          throwsA(isA<AnalyticsException>()),
        );

        verify(
          () => mockChannel.logScreenView(
            screenName: tScreenName,
            screenClass: tScreenClass,
          ),
        ).called(1);
      });

      test('should wrap unexpected exceptions in AnalyticsException', () async {
        when(
          () => mockChannel.logScreenView(
            screenName: any(named: 'screenName'),
            screenClass: any(named: 'screenClass'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        expect(
          () => datasource.logScreenView(
            screenName: tScreenName,
            screenClass: tScreenClass,
          ),
          throwsA(
            isA<AnalyticsException>().having(
              (e) => e.message,
              'message',
              'Erro inesperado ao logar visualização de tela',
            ),
          ),
        );

        verify(
          () => mockChannel.logScreenView(
            screenName: tScreenName,
            screenClass: tScreenClass,
          ),
        ).called(1);
      });
    });
  });
}
