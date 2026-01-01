import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/data/models/pokemon_model.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

import '../../../../helpers/fixture_reader.dart';

void main() {
  const tPokemonModel = PokemonModel(
    id: 1,
    pokeNum: '001',
    name: 'Bulbasaur',
    img: 'http://www.serebii.net/pokemongo/pokemon/001.png',
    type: ['Grass', 'Poison'],
    height: '0.71 m',
    weight: '6.9 kg',
    candy: 'Bulbasaur Candy',
    candyCount: 25,
    egg: '2 km',
    spawnChance: 0.69,
    avgSpawns: 69,
    spawnTime: '20:00',
    multipliers: [1.58],
    weaknesses: ['Fire', 'Ice', 'Flying', 'Psychic'],
    nextEvolution: [EvolutionModel(pokeNum: '002', name: 'Ivysaur')],
  );

  group('PokemonModel', () {
    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('pokemon_fixture.json'),
        );
        final result = PokemonModel.fromJson(jsonMap);
        expect(result, tPokemonModel);
      });

      test('should handle int values for numeric fields', () {
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'num': '001',
          'name': 'Bulbasaur',
          'img': 'http://test.png',
          'type': ['Grass'],
          'height': '0.71 m',
          'weight': '6.9 kg',
          'candy': 'Candy',
          'egg': '2 km',
          'spawn_chance': 1,
          'avg_spawns': 69,
          'spawn_time': '20:00',
          'multipliers': [1, 2],
          'weaknesses': ['Fire'],
        };

        final result = PokemonModel.fromJson(jsonMap);
        expect(result.spawnChance, 1.0);
        expect(result.avgSpawns, 69.0);
        expect(result.multipliers, [1.0, 2.0]);
      });
    });

    group('toEntity', () {
      test('should return a Pokemon entity with correct data', () {
        final result = tPokemonModel.toEntity();

        expect(result, isA<Pokemon>());
        expect(result.id, tPokemonModel.id);
        expect(result.pokeNum, tPokemonModel.pokeNum);
        expect(result.name, tPokemonModel.name);
        expect(result.img, tPokemonModel.img);
        expect(result.type, tPokemonModel.type);
      });
    });
  });

  group('EvolutionModel', () {
    const tEvolutionModel = EvolutionModel(pokeNum: '002', name: 'Ivysaur');

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        'num': '002',
        'name': 'Ivysaur',
      };

      final result = EvolutionModel.fromJson(jsonMap);
      expect(result, tEvolutionModel);
    });

    test('toEntity should return an Evolution entity', () {
      final result = tEvolutionModel.toEntity();

      expect(result, isA<Evolution>());
      expect(result.pokeNum, '002');
      expect(result.name, 'Ivysaur');
    });
  });
}
