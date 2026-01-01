import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
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

  group('PokemonsListCubit', () {
    test('initial state should be PokemonsListInitial', () {
      expect(cubit.state, isA<PokemonsListInitial>());
    });

    blocTest<PokemonsListCubit, PokemonsListState>(
      'should emit [Loading, Success] when data is gotten successfully',
      build: () {
        when(
          () => mockGetPokemons(),
        ).thenAnswer((_) async => const Right(tPokemons));
        return cubit;
      },
      act: (cubit) => cubit.loadPokemons(),
      expect: () => [
        isA<PokemonsListLoading>(),
        isA<PokemonsListSuccess>()
            .having((state) => state.pokemons, 'pokemons', tPokemons)
            .having((state) => state.pokemons.length, 'pokemons length', 1)
            .having(
              (state) => state.pokemons[0].name,
              'first pokemon name',
              'Bulbasaur',
            ),
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
          (_) async =>
              const Left(UnexpectedFailure(message: 'Unexpected error')),
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

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should sort pokemons alphabetically when in Success state',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tMultiplePokemons,
          allPokemons: tMultiplePokemons,
        ),
        act: (cubit) => cubit.applySortOrder(SortOrder.alphabetical),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.alphabetical)
              .having((s) => s.pokemons[0].name, 'first pokemon', 'Bulbasaur')
              .having((s) => s.pokemons[1].name, 'second pokemon', 'Ivysaur')
              .having((s) => s.pokemons[2].name, 'third pokemon', 'Venusaur'),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should sort pokemons by ID ascending',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tMultiplePokemons,
          allPokemons: tMultiplePokemons,
        ),
        act: (cubit) => cubit.applySortOrder(SortOrder.idAscending),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.idAscending)
              .having((s) => s.pokemons[0].id, 'first pokemon id', 1)
              .having((s) => s.pokemons[1].id, 'second pokemon id', 2)
              .having((s) => s.pokemons[2].id, 'third pokemon id', 3),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should sort pokemons by ID descending',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tMultiplePokemons,
          allPokemons: tMultiplePokemons,
        ),
        act: (cubit) => cubit.applySortOrder(SortOrder.idDescending),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.idDescending)
              .having((s) => s.pokemons[0].id, 'first pokemon id', 3)
              .having((s) => s.pokemons[1].id, 'second pokemon id', 2)
              .having((s) => s.pokemons[2].id, 'third pokemon id', 1),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should not emit when not in Success state',
        build: () => cubit,
        seed: () => const PokemonsListInitial(),
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

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should filter by type and apply sort order',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tMixedTypePokemons,
          allPokemons: tMixedTypePokemons,
        ),
        act: (cubit) => cubit.applyFilters(SortOrder.alphabetical, 'Fire'),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.pokemons.length, 'pokemons length', 1)
              .having((s) => s.pokemons[0].name, 'pokemon name', 'Charmander')
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.alphabetical)
              .having((s) => s.typeFilter, 'typeFilter', 'Fire'),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should apply only sort order when typeFilter is null',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tMixedTypePokemons,
          allPokemons: tMixedTypePokemons,
        ),
        act: (cubit) => cubit.applyFilters(SortOrder.idDescending, null),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.pokemons.length, 'pokemons length', 3)
              .having((s) => s.pokemons[0].id, 'first pokemon id', 7)
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.idDescending)
              .having((s) => s.typeFilter, 'typeFilter', null),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should return empty list when type filter matches no pokemons',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tMixedTypePokemons,
          allPokemons: tMixedTypePokemons,
        ),
        act: (cubit) => cubit.applyFilters(SortOrder.none, 'Dragon'),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.pokemons, 'pokemons', isEmpty)
              .having((s) => s.typeFilter, 'typeFilter', 'Dragon'),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should handle case insensitive type filter',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tMixedTypePokemons,
          allPokemons: tMixedTypePokemons,
        ),
        act: (cubit) => cubit.applyFilters(SortOrder.none, 'grass'),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.pokemons.length, 'pokemons length', 1)
              .having((s) => s.pokemons[0].name, 'pokemon name', 'Bulbasaur')
              .having((s) => s.typeFilter, 'typeFilter', 'grass'),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should not emit when not in Success state',
        build: () => cubit,
        seed: () => const PokemonsListLoading(),
        act: (cubit) => cubit.applyFilters(SortOrder.alphabetical, 'Fire'),
        expect: () => [],
      );
    });

    group('clearFilters', () {
      const tFilteredPokemons = [
        Pokemon(
          id: 1,
          pokeNum: '001',
          name: 'Bulbasaur',
          img: 'http://test.png',
          type: ['Grass'],
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

      const tAllPokemons = [
        Pokemon(
          id: 1,
          pokeNum: '001',
          name: 'Bulbasaur',
          img: 'http://test.png',
          type: ['Grass'],
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
      ];

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should clear filters and restore all pokemons',
        build: () => cubit,
        seed: () => const PokemonsListSuccess(
          pokemons: tFilteredPokemons,
          allPokemons: tAllPokemons,
          sortOrder: SortOrder.alphabetical,
          typeFilter: 'Grass',
        ),
        act: (cubit) => cubit.clearFilters(),
        expect: () => [
          isA<PokemonsListSuccess>()
              .having((s) => s.pokemons, 'pokemons', tAllPokemons)
              .having((s) => s.sortOrder, 'sortOrder', SortOrder.none)
              .having((s) => s.typeFilter, 'typeFilter', null),
        ],
      );

      blocTest<PokemonsListCubit, PokemonsListState>(
        'should not emit when not in Success state',
        build: () => cubit,
        seed: () => const PokemonsListInitial(),
        act: (cubit) => cubit.clearFilters(),
        expect: () => [],
      );
    });
  });
}
