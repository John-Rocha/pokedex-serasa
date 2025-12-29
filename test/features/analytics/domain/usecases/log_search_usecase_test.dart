import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_search_usecase.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  late LogSearchUseCase useCase;
  late MockAnalyticsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnalyticsRepository();
    useCase = LogSearchUseCase(repository: mockRepository);
  });

  group('LogSearchUseCase', () {
    const tSearchTerm = 'Pikachu';
    const tResultsCount = 5;

    test('should call repository logSearch with all parameters', () async {
      when(
        () => mockRepository.logSearch(
          any(),
          resultsCount: any(named: 'resultsCount'),
        ),
      ).thenAnswer((_) async => Future.value());

      await useCase(
        searchTerm: tSearchTerm,
        resultsCount: tResultsCount,
      );

      verify(
        () => mockRepository.logSearch(
          tSearchTerm,
          resultsCount: tResultsCount,
        ),
      ).called(1);
    });

    test(
      'should call repository logSearch without resultsCount when null',
      () async {
        when(
          () => mockRepository.logSearch(
            any(),
            resultsCount: any(named: 'resultsCount'),
          ),
        ).thenAnswer((_) async => Future.value());

        await useCase(searchTerm: tSearchTerm);

        verify(
          () => mockRepository.logSearch(
            tSearchTerm,
            resultsCount: null,
          ),
        ).called(1);
      },
    );

    test('should handle zero results count', () async {
      when(
        () => mockRepository.logSearch(
          any(),
          resultsCount: any(named: 'resultsCount'),
        ),
      ).thenAnswer((_) async => Future.value());

      await useCase(
        searchTerm: tSearchTerm,
        resultsCount: 0,
      );

      verify(
        () => mockRepository.logSearch(
          tSearchTerm,
          resultsCount: 0,
        ),
      ).called(1);
    });

    test('should propagate exceptions from repository', () async {
      when(
        () => mockRepository.logSearch(
          any(),
          resultsCount: any(named: 'resultsCount'),
        ),
      ).thenThrow(Exception('Repository error'));

      expect(
        () => useCase(
          searchTerm: tSearchTerm,
          resultsCount: tResultsCount,
        ),
        throwsA(isA<Exception>()),
      );

      verify(
        () => mockRepository.logSearch(
          tSearchTerm,
          resultsCount: tResultsCount,
        ),
      ).called(1);
    });
  });
}
