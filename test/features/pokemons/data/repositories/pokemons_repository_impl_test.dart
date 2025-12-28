import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_serasa/core/errors/exceptions.dart';
import 'package:pokedex_serasa/core/errors/failures.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_local_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/datasources/pokemons_remote_datasource.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';
import 'package:pokedex_serasa/features/pokemons/data/repositories/pokemons_repository_impl.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class MockRemoteDatasource extends Mock implements PokemonsRemoteDatasource {}
class MockLocalDatasource extends Mock implements PokemonsLocalDatasource {}

void main() {
  late PokemonsRepositoryImpl repository;
  late MockRemoteDatasource mockRemoteDatasource;
  late MockLocalDatasource mockLocalDatasource;

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    repository = PokemonsRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
    );
  });

  const tPokemonModels = [
    PokemonModel(
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

  group('getPokemons', () {
    test('should return remote data when remote datasource succeeds', () async {
      when(() => mockRemoteDatasource.getPokemons()).thenAnswer((_) async => tPokemonModels);

      final result = await repository.getPokemons();

      expect(result, isA<Right<Failure, List<Pokemon>>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons, isA<List<Pokemon>>());
          expect(pokemons.length, 1);
          expect(pokemons[0].name, 'Bulbasaur');
        },
      );
      verify(() => mockRemoteDatasource.getPokemons()).called(1);
      verifyNever(() => mockLocalDatasource.getPokemons());
    });

    test('should return local data when remote datasource throws NetworkException', () async {
      when(() => mockRemoteDatasource.getPokemons()).thenThrow(const NetworkException(message: 'Network error'));
      when(() => mockLocalDatasource.getPokemons()).thenAnswer((_) async => tPokemonModels);

      final result = await repository.getPokemons();

      expect(result, isA<Right<Failure, List<Pokemon>>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (pokemons) {
          expect(pokemons.length, 1);
          expect(pokemons[0].name, 'Bulbasaur');
        },
      );
      verify(() => mockRemoteDatasource.getPokemons()).called(1);
      verify(() => mockLocalDatasource.getPokemons()).called(1);
    });

    test('should return FileFailure when both datasources fail', () async {
      when(() => mockRemoteDatasource.getPokemons()).thenThrow(const NetworkException(message: 'Network error'));
      when(() => mockLocalDatasource.getPokemons()).thenThrow(const FileException(message: 'File error'));

      final result = await repository.getPokemons();

      expect(result, isA<Left<Failure, List<Pokemon>>>());
      result.fold(
        (failure) {
          expect(failure, isA<FileFailure>());
          expect(failure.message, 'File error');
        },
        (pokemons) => fail('Should not return success'),
      );
    });

    test('should return UnexpectedFailure when remote datasource throws unexpected error', () async {
      when(() => mockRemoteDatasource.getPokemons()).thenThrow(Exception('Unexpected error'));

      final result = await repository.getPokemons();

      expect(result, isA<Left<Failure, List<Pokemon>>>());
      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (pokemons) => fail('Should not return success'),
      );
    });

    test('should return UnexpectedFailure when local datasource throws unexpected error after remote fails', () async {
      when(() => mockRemoteDatasource.getPokemons()).thenThrow(const NetworkException(message: 'Network error'));
      when(() => mockLocalDatasource.getPokemons()).thenThrow(Exception('Unexpected local error'));

      final result = await repository.getPokemons();

      expect(result, isA<Left<Failure, List<Pokemon>>>());
      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (pokemons) => fail('Should not return success'),
      );
    });
  });
}
