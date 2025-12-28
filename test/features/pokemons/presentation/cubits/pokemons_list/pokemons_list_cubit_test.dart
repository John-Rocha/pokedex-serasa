import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/get_pokemons.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';

class MockGetPokemons extends Mock implements GetPokemons {}

void main() {
  late PokemonsListCubit cubit;
  late MockGetPokemons mockGetPokemons;

  setUp(() {
    mockGetPokemons = MockGetPokemons();
    cubit = PokemonsListCubit(getPokemons: mockGetPokemons);
  });

  tearDown(() {
    cubit.close();
  });

  const tPokemons = [
    Pokemon(
      id: 1,
      num: '001',
      name: 'Bulbasaur',
      img: 'http://test.png',
      type: ['Grass', 'Poison'],
      height: '0.71 m',
      weight: '6.9 kg',
      candy: 'Candy',
      egg: '2 km',
      spawnChance: 0.69,
      avgSpawns: 69,
      spawnTime: '20:00',
      weaknesses: ['Fire'],
    ),
  ];

  group('PokemonsListCubit', () {
    test('initial state should be PokemonsListInitial', () {
      expect(cubit.state, isA<PokemonsListInitial>());
    });

    blocTest<PokemonsListCubit, PokemonsListState>(
      'should emit [Loading, Success] when data is gotten successfully',
      build: () {
        when(() => mockGetPokemons()).thenAnswer((_) async => const Right(tPokemons));
        return cubit;
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        isA<PokemonsListLoading>(),
        isA<PokemonsListSuccess>()
            .having((state) => state.pokemons, 'pokemons', tPokemons)
            .having((state) => state.pokemons.length, 'pokemons length', 1)
            .having((state) => state.pokemons[0].name, 'first pokemon name', 'Bulbasaur'),
      ],
      verify: (_) {
        verify(() => mockGetPokemons()).called(1);
      },
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'should emit [Loading, Error] when getting data fails with NetworkFailure',
      build: () {
        when(() => mockGetPokemons()).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'Network error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        isA<PokemonsListLoading>(),
        isA<PokemonsListError>().having(
          (state) => state.message,
          'error message',
          'Network error',
        ),
      ],
      verify: (_) {
        verify(() => mockGetPokemons()).called(1);
      },
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'should emit [Loading, Error] when getting data fails with FileFailure',
      build: () {
        when(() => mockGetPokemons()).thenAnswer(
          (_) async => const Left(FileFailure(message: 'File not found')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        isA<PokemonsListLoading>(),
        isA<PokemonsListError>().having(
          (state) => state.message,
          'error message',
          'File not found',
        ),
      ],
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'should emit [Loading, Error] when getting data fails with UnexpectedFailure',
      build: () {
        when(() => mockGetPokemons()).thenAnswer(
          (_) async => const Left(UnexpectedFailure(message: 'Unexpected error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        isA<PokemonsListLoading>(),
        isA<PokemonsListError>().having(
          (state) => state.message,
          'error message',
          'Unexpected error',
        ),
      ],
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'should emit [Loading, Success] with empty list when no pokemons are returned',
      build: () {
        when(() => mockGetPokemons()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        isA<PokemonsListLoading>(),
        isA<PokemonsListSuccess>().having(
          (state) => state.pokemons,
          'pokemons',
          isEmpty,
        ),
      ],
    );
  });
}
