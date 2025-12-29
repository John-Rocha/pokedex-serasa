import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_screen_view_usecase.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  late LogScreenViewUseCase useCase;
  late MockAnalyticsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnalyticsRepository();
    useCase = LogScreenViewUseCase(repository: mockRepository);
  });

  group('LogScreenViewUseCase', () {
    const tScreenName = 'HomeScreen';
    const tScreenClass = 'HomePage';

    test(
      'should call repository logScreenView with correct parameters',
      () async {
        when(
          () => mockRepository.logScreenView(
            any(),
            any(),
          ),
        ).thenAnswer((_) async => Future.value());

        await useCase(
          screenName: tScreenName,
          screenClass: tScreenClass,
        );

        verify(
          () => mockRepository.logScreenView(
            tScreenName,
            tScreenClass,
          ),
        ).called(1);
      },
    );

    test('should return Future from repository', () async {
      when(
        () => mockRepository.logScreenView(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => Future.value());

      final result = useCase(
        screenName: tScreenName,
        screenClass: tScreenClass,
      );

      expect(result, isA<Future<void>>());
    });

    test('should propagate exceptions from repository', () async {
      when(
        () => mockRepository.logScreenView(
          any(),
          any(),
        ),
      ).thenThrow(Exception('Repository error'));

      expect(
        () => useCase(
          screenName: tScreenName,
          screenClass: tScreenClass,
        ),
        throwsA(isA<Exception>()),
      );

      verify(
        () => mockRepository.logScreenView(
          tScreenName,
          tScreenClass,
        ),
      ).called(1);
    });
  });
}
