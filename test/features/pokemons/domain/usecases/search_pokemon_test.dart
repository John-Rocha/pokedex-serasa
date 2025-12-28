import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/domain/repositories/pokemons_repository.dart';
import 'package:pokedex_serasa/features/pokemons/domain/usecases/search_pokemon.dart';

class MockPokemonsRepository extends Mock implements PokemonsRepository {}

void main() {
  late SearchPokemon usecase;
  late MockPokemonsRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonsRepository();
    usecase = SearchPokemon(repository: mockRepository);
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
    Pokemon(
      id: 2,
      num: '002',
      name: 'Ivysaur',
      img: 'http://test2.png',
      type: ['Grass', 'Poison'],
      height: '0.99 m',
      weight: '13.0 kg',
      candy: 'Candy',
      egg: 'Not in Eggs',
      spawnChance: 0.042,
      avgSpawns: 4.2,
      spawnTime: '07:00',
      weaknesses: ['Fire'],
    ),
    Pokemon(
      id: 25,
      num: '025',
      name: 'Pikachu',
      img: 'http://test3.png',
      type: ['Electric'],
      height: '0.4 m',
      weight: '6.0 kg',
      candy: 'Candy',
      egg: '2 km',
      spawnChance: 0.21,
      avgSpawns: 21,
      spawnTime: '04:00',
      weaknesses: ['Ground'],
    ),
  ];

  group('SearchPokemon', () {
    test('should return empty list when query is empty', () async {
      final result = await usecase('');

      expect(result, const Right([]));
      verifyNever(() => mockRepository.getPokemons());
    });

    test('should return filtered pokemons when searching by name', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Right(tPokemons),
      );

      final result = await usecase('bulbasaur');

      expect(result, isA<Right<Failure, List<Pokemon>>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons.length, 1);
          expect(pokemons[0].name, 'Bulbasaur');
        },
      );
      verify(() => mockRepository.getPokemons()).called(1);
    });

    test('should return filtered pokemons when searching by number', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Right(tPokemons),
      );

      final result = await usecase('025');

      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons.length, 1);
          expect(pokemons[0].name, 'Pikachu');
        },
      );
    });

    test('should be case insensitive when searching', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Right(tPokemons),
      );

      final result = await usecase('PIKACHU');

      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons.length, 1);
          expect(pokemons[0].name, 'Pikachu');
        },
      );
    });

    test(
      'should return multiple pokemons when query matches multiple results',
      () async {
        when(() => mockRepository.getPokemons()).thenAnswer(
          (_) async => const Right(tPokemons),
        );

        final result = await usecase('saur');

        result.fold(
          (failure) => fail('Should not return failure'),
          (pokemons) {
            expect(pokemons.length, 2);
            expect(pokemons[0].name, 'Bulbasaur');
            expect(pokemons[1].name, 'Ivysaur');
          },
        );
      },
    );

    test('should return empty list when no pokemon matches query', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Right(tPokemons),
      );

      final result = await usecase('charizard');

      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons, isEmpty);
        },
      );
    });

    test('should trim whitespace from query', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Right(tPokemons),
      );

      final result = await usecase('  pikachu  ');

      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons.length, 1);
          expect(pokemons[0].name, 'Pikachu');
        },
      );
    });

    test('should return failure when repository fails', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Left(NetworkFailure(message: 'Network error')),
      );

      final result = await usecase('pikachu');

      expect(result, isA<Left<Failure, List<Pokemon>>>());
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'Network error');
        },
        (pokemons) => fail('Should not return success'),
      );
    });

    test('should search by partial name match', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Right(tPokemons),
      );

      final result = await usecase('pik');

      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons.length, 1);
          expect(pokemons[0].name, 'Pikachu');
        },
      );
    });

    test('should search by partial number match', () async {
      when(() => mockRepository.getPokemons()).thenAnswer(
        (_) async => const Right(tPokemons),
      );

      final result = await usecase('02');

      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons.length, 2);
          expect(pokemons[0].num, '002');
          expect(pokemons[1].num, '025');
        },
      );
    });
  });
}
