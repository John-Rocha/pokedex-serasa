import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_pokemon_view_usecase.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

void main() {
  late LogPokemonViewUseCase useCase;
  late MockAnalyticsRepository mockRepository;

  setUp(() {
    mockRepository = MockAnalyticsRepository();
    useCase = LogPokemonViewUseCase(repository: mockRepository);
  });

  group('LogPokemonViewUseCase', () {
    const tPokemonId = 1;
    const tPokemonName = 'Bulbasaur';
    const tTypes = ['Grass', 'Poison'];

    test('should call repository logPokemonView with all parameters', () async {
      when(
        () => mockRepository.logPokemonView(
          any(),
          any(),
          types: any(named: 'types'),
        ),
      ).thenAnswer((_) async => Future.value());

      await useCase(
        pokemonId: tPokemonId,
        pokemonName: tPokemonName,
        types: tTypes,
      );

      verify(
        () => mockRepository.logPokemonView(
          tPokemonId,
          tPokemonName,
          types: tTypes,
        ),
      ).called(1);
    });

    test(
      'should call repository logPokemonView without types when null',
      () async {
        when(
          () => mockRepository.logPokemonView(
            any(),
            any(),
            types: any(named: 'types'),
          ),
        ).thenAnswer((_) async => Future.value());

        await useCase(
          pokemonId: tPokemonId,
          pokemonName: tPokemonName,
        );

        verify(
          () => mockRepository.logPokemonView(
            tPokemonId,
            tPokemonName,
            types: null,
          ),
        ).called(1);
      },
    );

    test('should handle empty types list', () async {
      when(
        () => mockRepository.logPokemonView(
          any(),
          any(),
          types: any(named: 'types'),
        ),
      ).thenAnswer((_) async => Future.value());

      await useCase(
        pokemonId: tPokemonId,
        pokemonName: tPokemonName,
        types: [],
      );

      verify(
        () => mockRepository.logPokemonView(
          tPokemonId,
          tPokemonName,
          types: [],
        ),
      ).called(1);
    });

    test('should propagate exceptions from repository', () async {
      when(
        () => mockRepository.logPokemonView(
          any(),
          any(),
          types: any(named: 'types'),
        ),
      ).thenThrow(Exception('Repository error'));

      expect(
        () => useCase(
          pokemonId: tPokemonId,
          pokemonName: tPokemonName,
          types: tTypes,
        ),
        throwsA(isA<Exception>()),
      );

      verify(
        () => mockRepository.logPokemonView(
          tPokemonId,
          tPokemonName,
          types: tTypes,
        ),
      ).called(1);
    });
  });
}
