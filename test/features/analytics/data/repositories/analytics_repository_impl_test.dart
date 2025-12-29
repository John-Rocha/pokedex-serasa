import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/analytics/data/datasources/analytics_native_datasource.dart';
import 'package:pokedex_serasa/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:pokedex_serasa/features/analytics/domain/entities/analytics_event.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';

class MockAnalyticsNativeDataSource extends Mock
    implements AnalyticsNativeDataSource {}

void main() {
  late AnalyticsRepository repository;
  late MockAnalyticsNativeDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAnalyticsNativeDataSource();
    repository = AnalyticsRepositoryImpl(nativeDataSource: mockDataSource);
  });

  group('AnalyticsRepositoryImpl', () {
    group('logEvent', () {
      final tEvent = AnalyticsEvent(
        name: 'test_event',
        parameters: {'key': 'value'},
        timestamp: DateTime(2024, 1, 1, 12, 0, 0),
      );

      test(
        'should call logEvent on datasource with correct parameters',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenAnswer((_) async => Future.value());

          await repository.logEvent(tEvent);

          verify(
            () => mockDataSource.logEvent(
              eventName: 'test_event',
              parameters: {'key': 'value'},
            ),
          ).called(1);
        },
      );

      test(
        'should throw AnalyticsFailure when datasource throws exception',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenThrow(
            const AnalyticsException('Datasource error'),
          );

          expect(
            () => repository.logEvent(tEvent),
            throwsA(
              isA<AnalyticsFailure>().having(
                (f) => f.message,
                'message',
                'Datasource error',
              ),
            ),
          );

          verify(
            () => mockDataSource.logEvent(
              eventName: 'test_event',
              parameters: {'key': 'value'},
            ),
          ).called(1);
        },
      );
    });

    group('logScreenView', () {
      const tScreenName = 'HomeScreen';
      const tScreenClass = 'HomePage';

      test(
        'should call logScreenView on datasource with correct parameters',
        () async {
          when(
            () => mockDataSource.logScreenView(
              screenName: any(named: 'screenName'),
              screenClass: any(named: 'screenClass'),
            ),
          ).thenAnswer((_) async => Future.value());

          await repository.logScreenView(tScreenName, tScreenClass);

          verify(
            () => mockDataSource.logScreenView(
              screenName: tScreenName,
              screenClass: tScreenClass,
            ),
          ).called(1);
        },
      );

      test(
        'should throw AnalyticsFailure when datasource throws exception',
        () async {
          when(
            () => mockDataSource.logScreenView(
              screenName: any(named: 'screenName'),
              screenClass: any(named: 'screenClass'),
            ),
          ).thenThrow(
            const AnalyticsException('Datasource error'),
          );

          expect(
            () => repository.logScreenView(tScreenName, tScreenClass),
            throwsA(
              isA<AnalyticsFailure>().having(
                (f) => f.message,
                'message',
                'Datasource error',
              ),
            ),
          );

          verify(
            () => mockDataSource.logScreenView(
              screenName: tScreenName,
              screenClass: tScreenClass,
            ),
          ).called(1);
        },
      );
    });

    group('logPokemonView', () {
      const tPokemonId = 1;
      const tPokemonName = 'Bulbasaur';
      const tTypes = ['Grass', 'Poison'];

      test(
        'should call logEvent with pokemon_view event and all parameters',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenAnswer((_) async => Future.value());

          await repository.logPokemonView(
            tPokemonId,
            tPokemonName,
            types: tTypes,
          );

          final captured = verify(
            () => mockDataSource.logEvent(
              eventName: captureAny(named: 'eventName'),
              parameters: captureAny(named: 'parameters'),
            ),
          ).captured;

          expect(captured[0], 'pokemon_view');
          expect(captured[1]['pokemon_id'], tPokemonId);
          expect(captured[1]['pokemon_name'], tPokemonName);
          expect(captured[1]['pokemon_types'], 'Grass,Poison');
          expect(captured[1]['timestamp'], isA<String>());
        },
      );

      test('should call logEvent without types when types is null', () async {
        when(
          () => mockDataSource.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async => Future.value());

        await repository.logPokemonView(tPokemonId, tPokemonName);

        final captured = verify(
          () => mockDataSource.logEvent(
            eventName: captureAny(named: 'eventName'),
            parameters: captureAny(named: 'parameters'),
          ),
        ).captured;

        expect(captured[0], 'pokemon_view');
        expect(captured[1]['pokemon_id'], tPokemonId);
        expect(captured[1]['pokemon_name'], tPokemonName);
        expect(captured[1].containsKey('pokemon_types'), false);
        expect(captured[1]['timestamp'], isA<String>());
      });

      test(
        'should throw AnalyticsFailure when datasource throws exception',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenThrow(
            const AnalyticsException('Datasource error'),
          );

          expect(
            () => repository.logPokemonView(
              tPokemonId,
              tPokemonName,
              types: tTypes,
            ),
            throwsA(
              isA<AnalyticsFailure>().having(
                (f) => f.message,
                'message',
                'Datasource error',
              ),
            ),
          );
        },
      );
    });

    group('logSearch', () {
      const tSearchTerm = 'Pikachu';
      const tResultsCount = 5;

      test(
        'should call logEvent with search_performed event and all parameters',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenAnswer((_) async => Future.value());

          await repository.logSearch(
            tSearchTerm,
            resultsCount: tResultsCount,
          );

          final captured = verify(
            () => mockDataSource.logEvent(
              eventName: captureAny(named: 'eventName'),
              parameters: captureAny(named: 'parameters'),
            ),
          ).captured;

          expect(captured[0], 'search_performed');
          expect(captured[1]['search_term'], tSearchTerm);
          expect(captured[1]['results_count'], tResultsCount);
          expect(captured[1]['timestamp'], isA<String>());
        },
      );

      test('should call logEvent without resultsCount when null', () async {
        when(
          () => mockDataSource.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async => Future.value());

        await repository.logSearch(tSearchTerm);

        final captured = verify(
          () => mockDataSource.logEvent(
            eventName: captureAny(named: 'eventName'),
            parameters: captureAny(named: 'parameters'),
          ),
        ).captured;

        expect(captured[0], 'search_performed');
        expect(captured[1]['search_term'], tSearchTerm);
        expect(captured[1].containsKey('results_count'), false);
        expect(captured[1]['timestamp'], isA<String>());
      });

      test(
        'should throw AnalyticsFailure when datasource throws exception',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenThrow(
            const AnalyticsException('Datasource error'),
          );

          expect(
            () =>
                repository.logSearch(tSearchTerm, resultsCount: tResultsCount),
            throwsA(
              isA<AnalyticsFailure>().having(
                (f) => f.message,
                'message',
                'Datasource error',
              ),
            ),
          );
        },
      );
    });

    group('logFilterApplied', () {
      const tTypes = ['Fire', 'Water'];
      const tSortBy = 'alphabetical';

      test(
        'should call logEvent with filter_applied event and all parameters',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenAnswer((_) async => Future.value());

          await repository.logFilterApplied(
            tTypes,
            sortBy: tSortBy,
          );

          final captured = verify(
            () => mockDataSource.logEvent(
              eventName: captureAny(named: 'eventName'),
              parameters: captureAny(named: 'parameters'),
            ),
          ).captured;

          expect(captured[0], 'filter_applied');
          expect(captured[1]['filter_types'], 'Fire,Water');
          expect(captured[1]['sort_by'], tSortBy);
          expect(captured[1]['filter_count'], 2);
          expect(captured[1]['timestamp'], isA<String>());
        },
      );

      test('should call logEvent without sortBy when null', () async {
        when(
          () => mockDataSource.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async => Future.value());

        await repository.logFilterApplied(tTypes);

        final captured = verify(
          () => mockDataSource.logEvent(
            eventName: captureAny(named: 'eventName'),
            parameters: captureAny(named: 'parameters'),
          ),
        ).captured;

        expect(captured[0], 'filter_applied');
        expect(captured[1]['filter_types'], 'Fire,Water');
        expect(captured[1].containsKey('sort_by'), false);
        expect(captured[1]['filter_count'], 2);
        expect(captured[1]['timestamp'], isA<String>());
      });

      test('should handle empty types list', () async {
        when(
          () => mockDataSource.logEvent(
            eventName: any(named: 'eventName'),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async => Future.value());

        await repository.logFilterApplied([]);

        final captured = verify(
          () => mockDataSource.logEvent(
            eventName: captureAny(named: 'eventName'),
            parameters: captureAny(named: 'parameters'),
          ),
        ).captured;

        expect(captured[0], 'filter_applied');
        expect(captured[1]['filter_types'], '');
        expect(captured[1]['filter_count'], 0);
      });

      test(
        'should throw AnalyticsFailure when datasource throws exception',
        () async {
          when(
            () => mockDataSource.logEvent(
              eventName: any(named: 'eventName'),
              parameters: any(named: 'parameters'),
            ),
          ).thenThrow(
            const AnalyticsException('Datasource error'),
          );

          expect(
            () => repository.logFilterApplied(tTypes, sortBy: tSortBy),
            throwsA(
              isA<AnalyticsFailure>().having(
                (f) => f.message,
                'message',
                'Datasource error',
              ),
            ),
          );
        },
      );
    });
  });
}
