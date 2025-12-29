import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_filter_usecase.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  late LogFilterUseCase useCase;
  late MockAnalyticsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnalyticsRepository();
    useCase = LogFilterUseCase(repository: mockRepository);
  });

  group('LogFilterUseCase', () {
    const tTypes = ['Fire', 'Water'];
    const tSortBy = 'alphabetical';

    test(
      'should call repository logFilterApplied with all parameters',
      () async {
        when(
          () => mockRepository.logFilterApplied(
            any(),
            sortBy: any(named: 'sortBy'),
          ),
        ).thenAnswer((_) async => Future.value());

        await useCase(
          types: tTypes,
          sortBy: tSortBy,
        );

        verify(
          () => mockRepository.logFilterApplied(
            tTypes,
            sortBy: tSortBy,
          ),
        ).called(1);
      },
    );

    test(
      'should call repository logFilterApplied without sortBy when null',
      () async {
        when(
          () => mockRepository.logFilterApplied(
            any(),
            sortBy: any(named: 'sortBy'),
          ),
        ).thenAnswer((_) async => Future.value());

        await useCase(types: tTypes);

        verify(
          () => mockRepository.logFilterApplied(
            tTypes,
            sortBy: null,
          ),
        ).called(1);
      },
    );

    test('should handle empty types list', () async {
      when(
        () => mockRepository.logFilterApplied(
          any(),
          sortBy: any(named: 'sortBy'),
        ),
      ).thenAnswer((_) async => Future.value());

      await useCase(types: []);

      verify(
        () => mockRepository.logFilterApplied(
          [],
          sortBy: null,
        ),
      ).called(1);
    });

    test('should propagate exceptions from repository', () async {
      when(
        () => mockRepository.logFilterApplied(
          any(),
          sortBy: any(named: 'sortBy'),
        ),
      ).thenThrow(Exception('Repository error'));

      expect(
        () => useCase(
          types: tTypes,
          sortBy: tSortBy,
        ),
        throwsA(isA<Exception>()),
      );

      verify(
        () => mockRepository.logFilterApplied(
          tTypes,
          sortBy: tSortBy,
        ),
      ).called(1);
    });
  });
}
