import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_response_model.dart';

import '../../../../helpers/fixture_reader.dart';

void main() {
  group('PokemonResponseModel', () {
    group('fromJson', () {
      test('should parse JSON with pokemon array', () {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('pokemons_response_fixture.json'),
        );

        final result = PokemonResponseModel.fromJson(jsonMap);

        expect(result.pokemon, isA<List<PokemonModel>>());
        expect(result.pokemon.length, 2);
        expect(result.pokemon[0].name, 'Bulbasaur');
        expect(result.pokemon[1].name, 'Ivysaur');
      });

      test('should handle empty pokemon array', () {
        final Map<String, dynamic> jsonMap = {'pokemon': []};

        final result = PokemonResponseModel.fromJson(jsonMap);

        expect(result.pokemon, isEmpty);
      });

      test('should parse JSON with single pokemon', () {
        final Map<String, dynamic> jsonMap = {
          'pokemon': [
            {
              'id': 1,
              'num': '001',
              'name': 'Bulbasaur',
              'img': 'http://test.png',
              'type': ['Grass', 'Poison'],
              'height': '0.71 m',
              'weight': '6.9 kg',
              'candy': 'Bulbasaur Candy',
              'candy_count': 25,
              'egg': '2 km',
              'spawn_chance': 0.69,
              'avg_spawns': 69,
              'spawn_time': '20:00',
              'multipliers': [1.58],
              'weaknesses': ['Fire', 'Ice'],
            },
          ],
        };

        final result = PokemonResponseModel.fromJson(jsonMap);

        expect(result.pokemon.length, 1);
        expect(result.pokemon[0].name, 'Bulbasaur');
        expect(result.pokemon[0].id, 1);
      });

      test('should parse JSON with multiple pokemons', () {
        final Map<String, dynamic> jsonMap = {
          'pokemon': List.generate(
            5,
            (index) => {
              'id': index + 1,
              'num': '00${index + 1}',
              'name': 'Pokemon${index + 1}',
              'img': 'http://test$index.png',
              'type': ['Type'],
              'height': '1 m',
              'weight': '10 kg',
              'candy': 'Candy',
              'egg': '2 km',
              'spawn_chance': 0.5,
              'avg_spawns': 50,
              'spawn_time': '12:00',
              'weaknesses': ['Fire'],
            },
          ),
        };

        final result = PokemonResponseModel.fromJson(jsonMap);

        expect(result.pokemon.length, 5);
        expect(result.pokemon[0].name, 'Pokemon1');
        expect(result.pokemon[4].name, 'Pokemon5');
      });

      test('should correctly parse all pokemon models from array', () {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('pokemons_response_fixture.json'),
        );

        final result = PokemonResponseModel.fromJson(jsonMap);

        expect(result.pokemon[0], isA<PokemonModel>());
        expect(result.pokemon[1], isA<PokemonModel>());
      });
    });

    group('Equatable', () {
      test('should support value equality', () {
        const pokemon1 = PokemonModel(
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
        );

        const response1 = PokemonResponseModel(pokemon: [pokemon1]);
        const response2 = PokemonResponseModel(pokemon: [pokemon1]);

        expect(response1, response2);
      });

      test('should not be equal when pokemon lists are different', () {
        const pokemon1 = PokemonModel(
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
        );

        const pokemon2 = PokemonModel(
          id: 2,
          pokeNum: '002',
          name: 'Ivysaur',
          img: 'http://test2.png',
          type: ['Grass'],
          height: '0.99 m',
          weight: '13.0 kg',
          candy: 'Candy',
          egg: '2 km',
          spawnChance: 0.42,
          avgSpawns: 42,
          spawnTime: '07:00',
          weaknesses: ['Fire'],
        );

        const response1 = PokemonResponseModel(pokemon: [pokemon1]);
        const response2 = PokemonResponseModel(pokemon: [pokemon2]);

        expect(response1, isNot(response2));
      });

      test('should not be equal when list sizes are different', () {
        const pokemon1 = PokemonModel(
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
        );

        const response1 = PokemonResponseModel(pokemon: [pokemon1]);
        const response2 = PokemonResponseModel(pokemon: [pokemon1, pokemon1]);

        expect(response1, isNot(response2));
      });

      test('empty lists should be equal', () {
        const response1 = PokemonResponseModel(pokemon: []);
        const response2 = PokemonResponseModel(pokemon: []);

        expect(response1, response2);
      });
    });

    group('props', () {
      test('should have correct props', () {
        const pokemon = PokemonModel(
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
        );

        const response = PokemonResponseModel(pokemon: [pokemon]);

        expect(response.props, [
          [pokemon],
        ]);
      });

      test('should have props with empty list', () {
        const response = PokemonResponseModel(pokemon: []);

        expect(response.props, [[]]);
      });
    });

    group('constructor', () {
      test('should create instance with pokemon list', () {
        const pokemon = PokemonModel(
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
        );

        const response = PokemonResponseModel(pokemon: [pokemon]);

        expect(response.pokemon, [pokemon]);
        expect(response.pokemon.length, 1);
      });

      test('should create instance with empty list', () {
        const response = PokemonResponseModel(pokemon: []);

        expect(response.pokemon, isEmpty);
        expect(response.pokemon, isA<List<PokemonModel>>());
      });
    });

    group('Integration', () {
      test('should parse and maintain all pokemon data from fixture', () {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('pokemons_response_fixture.json'),
        );

        final result = PokemonResponseModel.fromJson(jsonMap);

        // Check Bulbasaur
        expect(result.pokemon[0].id, 1);
        expect(result.pokemon[0].pokeNum, '001');
        expect(result.pokemon[0].name, 'Bulbasaur');
        expect(result.pokemon[0].type, contains('Grass'));
        expect(result.pokemon[0].type, contains('Poison'));

        // Check Ivysaur
        expect(result.pokemon[1].id, 2);
        expect(result.pokemon[1].pokeNum, '002');
        expect(result.pokemon[1].name, 'Ivysaur');
        expect(result.pokemon[1].type, contains('Grass'));
        expect(result.pokemon[1].type, contains('Poison'));
      });

      test('should handle full response model workflow', () {
        // Create from JSON
        final jsonMap = {
          'pokemon': [
            {
              'id': 25,
              'num': '025',
              'name': 'Pikachu',
              'img': 'http://pikachu.png',
              'type': ['Electric'],
              'height': '0.4 m',
              'weight': '6.0 kg',
              'candy': 'Pikachu Candy',
              'egg': '2 km',
              'spawn_chance': 0.21,
              'avg_spawns': 21,
              'spawn_time': '04:00',
              'weaknesses': ['Ground'],
            },
          ],
        };

        final response = PokemonResponseModel.fromJson(jsonMap);

        // Verify response
        expect(response, isA<PokemonResponseModel>());
        expect(response.pokemon.length, 1);

        // Verify pokemon data
        final pikachu = response.pokemon[0];
        expect(pikachu.name, 'Pikachu');
        expect(pikachu.pokeNum, '025');
        expect(pikachu.type, ['Electric']);
        expect(pikachu.weaknesses, ['Ground']);
      });
    });
  });
}
