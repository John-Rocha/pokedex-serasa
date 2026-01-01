import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/search_pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_state.dart';

class MockSearchPokemon extends Mock implements SearchPokemon {}

void main() {
  late PokemonSearchCubit cubit;
  late MockSearchPokemon mockSearchPokemon;

  setUp(() {
    mockSearchPokemon = MockSearchPokemon();
    cubit = PokemonSearchCubit(searchPokemon: mockSearchPokemon);
  });

  tearDown(() {
    cubit.close();
  });

  const tPokemons = [
    Pokemon(
      id: 1,
      pokeNum: '001',
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

  group('PokemonSearchCubit', () {
    test('initial state should be PokemonSearchInitial', () {
      expect(cubit.state, isA<PokemonSearchInitial>());
    });

    blocTest<PokemonSearchCubit, PokemonSearchState>(
      'should emit [Initial] when search is called with empty query',
      build: () => cubit,
      act: (cubit) => cubit.search(''),
      expect: () => [
        isA<PokemonSearchInitial>(),
      ],
      verify: (_) {
        verifyNever(() => mockSearchPokemon(''));
      },
    );

    blocTest<PokemonSearchCubit, PokemonSearchState>(
      'should emit [Loading, Success] when search finds pokemons',
      build: () {
        when(() => mockSearchPokemon(any())).thenAnswer(
          (_) async => const Right(tPokemons),
        );
        return cubit;
      },
      act: (cubit) => cubit.search('bulbasaur'),
      expect: () => [
        isA<PokemonSearchLoading>(),
        isA<PokemonSearchSuccess>()
            .having((state) => state.pokemons, 'pokemons', tPokemons)
            .having((state) => state.pokemons.length, 'pokemons length', 1),
      ],
      verify: (_) {
        verify(() => mockSearchPokemon('bulbasaur')).called(1);
      },
    );

    blocTest<PokemonSearchCubit, PokemonSearchState>(
      'should emit [Loading, Empty] when search finds no pokemons',
      build: () {
        when(() => mockSearchPokemon(any())).thenAnswer(
          (_) async => const Right([]),
        );
        return cubit;
      },
      act: (cubit) => cubit.search('charizard'),
      expect: () => [
        isA<PokemonSearchLoading>(),
        isA<PokemonSearchEmpty>().having(
          (state) => state.query,
          'query',
          'charizard',
        ),
      ],
      verify: (_) {
        verify(() => mockSearchPokemon('charizard')).called(1);
      },
    );

    blocTest<PokemonSearchCubit, PokemonSearchState>(
      'should emit [Loading, Error] when search fails',
      build: () {
        when(() => mockSearchPokemon(any())).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'Network error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.search('pikachu'),
      expect: () => [
        isA<PokemonSearchLoading>(),
        isA<PokemonSearchError>().having(
          (state) => state.message,
          'error message',
          'Network error',
        ),
      ],
      verify: (_) {
        verify(() => mockSearchPokemon('pikachu')).called(1);
      },
    );

    blocTest<PokemonSearchCubit, PokemonSearchState>(
      'should emit [Initial] when clear is called',
      build: () => cubit,
      seed: () => const PokemonSearchSuccess(pokemons: tPokemons),
      act: (cubit) => cubit.clear(),
      expect: () => [
        isA<PokemonSearchInitial>(),
      ],
    );

    blocTest<PokemonSearchCubit, PokemonSearchState>(
      'should handle FileFailure',
      build: () {
        when(() => mockSearchPokemon(any())).thenAnswer(
          (_) async => const Left(FileFailure(message: 'File error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.search('test'),
      expect: () => [
        isA<PokemonSearchLoading>(),
        isA<PokemonSearchError>().having(
          (state) => state.message,
          'error message',
          'File error',
        ),
      ],
    );

    blocTest<PokemonSearchCubit, PokemonSearchState>(
      'should handle UnexpectedFailure',
      build: () {
        when(() => mockSearchPokemon(any())).thenAnswer(
          (_) async =>
              const Left(UnexpectedFailure(message: 'Unexpected error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.search('test'),
      expect: () => [
        isA<PokemonSearchLoading>(),
        isA<PokemonSearchError>().having(
          (state) => state.message,
          'error message',
          'Unexpected error',
        ),
      ],
    );

    group('applySortOrder', () {
      const tMultiplePokemons = [
        Pokemon(
          id: 3,
          pokeNum: '003',
          name: 'Venusaur',
          img: 'http://test.png',
          type: ['Grass', 'Poison'],
          height: '2.01 m',
          weight: '100.0 kg',
          candy: 'Candy',
          egg: '2 km',
          spawnChance: 0.017,
          avgSpawns: 1.7,
          spawnTime: '11:00',
          weaknesses: ['Fire'],
        ),
        Pokemon(
          id: 1,
          pokeNum: '001',
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
        Pokemon(
          id: 2,
          pokeNum: '002',
          name: 'Ivysaur',
          img: 'http://test.png',
          type: ['Grass', 'Poison'],
          height: '0.99 m',
          weight: '13.0 kg',
          candy: 'Candy',
          egg: '2 km',
          spawnChance: 0.042,
          avgSpawns: 4.2,
          spawnTime: '07:00',
          weaknesses: ['Fire'],
        ),
      ];

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should sort pokemons alphabetically when in Success state',
        build: () => cubit,
        seed: () => const PokemonSearchSuccess(
          pokemons: tMultiplePokemons,
        ),
        act: (cubit) => cubit.applySortOrder(SortOrder.alphabetical),
        expect: () => [
          isA<PokemonSearchSuccess>()
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.alphabetical)
              .having((s) => s.pokemons[0].name, 'first pokemon', 'Bulbasaur')
              .having((s) => s.pokemons[1].name, 'second pokemon', 'Ivysaur')
              .having((s) => s.pokemons[2].name, 'third pokemon', 'Venusaur'),
        ],
      );

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should sort pokemons by ID ascending',
        build: () => cubit,
        seed: () => const PokemonSearchSuccess(
          pokemons: tMultiplePokemons,
        ),
        act: (cubit) => cubit.applySortOrder(SortOrder.idAscending),
        expect: () => [
          isA<PokemonSearchSuccess>()
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.idAscending)
              .having((s) => s.pokemons[0].id, 'first pokemon id', 1)
              .having((s) => s.pokemons[1].id, 'second pokemon id', 2)
              .having((s) => s.pokemons[2].id, 'third pokemon id', 3),
        ],
      );

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should sort pokemons by ID descending',
        build: () => cubit,
        seed: () => const PokemonSearchSuccess(
          pokemons: tMultiplePokemons,
        ),
        act: (cubit) => cubit.applySortOrder(SortOrder.idDescending),
        expect: () => [
          isA<PokemonSearchSuccess>()
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.idDescending)
              .having((s) => s.pokemons[0].id, 'first pokemon id', 3)
              .having((s) => s.pokemons[1].id, 'second pokemon id', 2)
              .having((s) => s.pokemons[2].id, 'third pokemon id', 1),
        ],
      );

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should not emit when not in Success state',
        build: () => cubit,
        seed: () => const PokemonSearchInitial(),
        act: (cubit) => cubit.applySortOrder(SortOrder.alphabetical),
        expect: () => [],
      );
    });

    group('applyFilters', () {
      const tMixedTypePokemons = [
        Pokemon(
          id: 1,
          pokeNum: '001',
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
        Pokemon(
          id: 4,
          pokeNum: '004',
          name: 'Charmander',
          img: 'http://test.png',
          type: ['Fire'],
          height: '0.6 m',
          weight: '8.5 kg',
          candy: 'Candy',
          egg: '2 km',
          spawnChance: 0.25,
          avgSpawns: 25,
          spawnTime: '08:00',
          weaknesses: ['Water'],
        ),
        Pokemon(
          id: 7,
          pokeNum: '007',
          name: 'Squirtle',
          img: 'http://test.png',
          type: ['Water'],
          height: '0.5 m',
          weight: '9.0 kg',
          candy: 'Candy',
          egg: '2 km',
          spawnChance: 0.58,
          avgSpawns: 58,
          spawnTime: '04:00',
          weaknesses: ['Electric'],
        ),
      ];

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should filter by type and apply sort order',
        build: () {
          when(() => mockSearchPokemon(any())).thenAnswer(
            (_) async => const Right(tMixedTypePokemons),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.search('a');
          cubit.applyFilters(SortOrder.alphabetical, 'Fire');
        },
        skip: 2,
        expect: () => [
          isA<PokemonSearchLoading>(),
          isA<PokemonSearchSuccess>()
              .having((s) => s.pokemons.length, 'pokemons length', 1)
              .having((s) => s.pokemons[0].name, 'pokemon name', 'Charmander')
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.alphabetical)
              .having((s) => s.typeFilter, 'typeFilter', 'Fire'),
        ],
      );

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should apply only sort order when typeFilter is null',
        build: () {
          when(() => mockSearchPokemon(any())).thenAnswer(
            (_) async => const Right(tMixedTypePokemons),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.search('a');
          cubit.applyFilters(SortOrder.idDescending, null);
        },
        skip: 2,
        expect: () => [
          isA<PokemonSearchLoading>(),
          isA<PokemonSearchSuccess>()
              .having((s) => s.pokemons.length, 'pokemons length', 3)
              .having((s) => s.pokemons[0].id, 'first pokemon id', 7)
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.idDescending)
              .having((s) => s.typeFilter, 'typeFilter', null),
        ],
      );

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should emit Empty when filter results in no pokemons',
        build: () {
          when(() => mockSearchPokemon(any())).thenAnswer(
            (_) async => const Right(tMixedTypePokemons),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.search('a');
          cubit.applyFilters(SortOrder.none, 'Dragon');
        },
        skip: 2,
        expect: () => [
          isA<PokemonSearchLoading>(),
          isA<PokemonSearchEmpty>().having((s) => s.query, 'query', 'a'),
        ],
      );

      blocTest<PokemonSearchCubit, PokemonSearchState>(
        'should handle case insensitive type filter',
        build: () {
          when(() => mockSearchPokemon(any())).thenAnswer(
            (_) async => const Right(tMixedTypePokemons),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.search('a');
          cubit.applyFilters(SortOrder.none, 'fire');
        },
        skip: 2,
        expect: () => [
          isA<PokemonSearchLoading>(),
          isA<PokemonSearchSuccess>()
              .having((s) => s.pokemons.length, 'pokemons length', 1)
              .having((s) => s.pokemons[0].name, 'pokemon name', 'Charmander')
              .having((s) => s.typeFilter, 'typeFilter', 'fire'),
        ],
      );
    });
  });
}
