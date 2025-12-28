import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/utils/pokemon_types_helper.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

void main() {
  group('PokemonTypesHelper', () {
    group('extractUniqueTypes', () {
      test('should return empty list when pokemons list is empty', () {
        final result = PokemonTypesHelper.extractUniqueTypes([]);

        expect(result, isEmpty);
      });

      test('should extract unique types from single pokemon', () {
        const pokemons = [
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

        final result = PokemonTypesHelper.extractUniqueTypes(pokemons);

        expect(result, ['Grass', 'Poison']);
      });

      test('should extract and sort unique types from multiple pokemons', () {
        const pokemons = [
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
            id: 4,
            num: '004',
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
            num: '007',
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

        final result = PokemonTypesHelper.extractUniqueTypes(pokemons);

        expect(result, ['Fire', 'Grass', 'Poison', 'Water']);
      });

      test('should remove duplicate types and sort alphabetically', () {
        const pokemons = [
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
          Pokemon(
            id: 4,
            num: '004',
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

        final result = PokemonTypesHelper.extractUniqueTypes(pokemons);

        expect(result, ['Fire', 'Grass', 'Poison']);
        expect(result.length, 3);
      });

      test('should handle pokemon with single type', () {
        const pokemons = [
          Pokemon(
            id: 25,
            num: '025',
            name: 'Pikachu',
            img: 'http://test.png',
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

        final result = PokemonTypesHelper.extractUniqueTypes(pokemons);

        expect(result, ['Electric']);
      });

      test('should maintain alphabetical order', () {
        const pokemons = [
          Pokemon(
            id: 1,
            num: '001',
            name: 'Test1',
            img: 'http://test.png',
            type: ['Water', 'Fire', 'Grass', 'Electric'],
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

        final result = PokemonTypesHelper.extractUniqueTypes(pokemons);

        expect(result, ['Electric', 'Fire', 'Grass', 'Water']);
      });
    });
  });
}
