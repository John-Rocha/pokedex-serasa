import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/features/analytics/domain/entities/analytics_event.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_event_usecase.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  late LogEventUseCase useCase;
  late MockAnalyticsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnalyticsRepository();
    useCase = LogEventUseCase(repository: mockRepository);
    registerFallbackValue(
      AnalyticsEvent(
        name: '',
        parameters: {},
        timestamp: DateTime.now(),
      ),
    );
  });

  group('LogEventUseCase', () {
    const tEventName = 'test_event';
    final tParameters = {'key': 'value', 'count': 42};

    test(
      'should create an AnalyticsEvent and call repository logEvent',
      () async {
        when(() => mockRepository.logEvent(any())).thenAnswer(
          (_) async => Future.value(),
        );

        await useCase(
          eventName: tEventName,
          parameters: tParameters,
        );

        final captured =
            verify(
                  () => mockRepository.logEvent(captureAny()),
                ).captured.single
                as AnalyticsEvent;

        expect(captured.name, tEventName);
        expect(captured.parameters, tParameters);
        expect(captured.timestamp, isA<DateTime>());
      },
    );

    test('should create event with current timestamp', () async {
      final beforeCall = DateTime.now();

      when(() => mockRepository.logEvent(any())).thenAnswer(
        (_) async => Future.value(),
      );

      await useCase(
        eventName: tEventName,
        parameters: tParameters,
      );

      final afterCall = DateTime.now();

      final captured =
          verify(
                () => mockRepository.logEvent(captureAny()),
              ).captured.single
              as AnalyticsEvent;

      expect(
        captured.timestamp.isAfter(
          beforeCall.subtract(
            const Duration(seconds: 1),
          ),
        ),
        true,
      );
      expect(
        captured.timestamp.isBefore(
          afterCall.add(
            const Duration(seconds: 1),
          ),
        ),
        true,
      );
    });

    test('should handle empty parameters', () async {
      when(() => mockRepository.logEvent(any())).thenAnswer(
        (_) async => Future.value(),
      );

      await useCase(
        eventName: tEventName,
        parameters: {},
      );

      final captured =
          verify(
                () => mockRepository.logEvent(captureAny()),
              ).captured.single
              as AnalyticsEvent;

      expect(captured.parameters, {});
    });

    test('should propagate exceptions from repository', () async {
      when(() => mockRepository.logEvent(any())).thenThrow(
        Exception('Repository error'),
      );

      expect(
        () => useCase(
          eventName: tEventName,
          parameters: tParameters,
        ),
        throwsA(isA<Exception>()),
      );

      verify(() => mockRepository.logEvent(any())).called(1);
    });
  });
}
