import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

void main() {
  group('Evolution', () {
    test('should support value equality', () {
      // Arrange
      const evolution1 = Evolution(pokeNum: '002', name: 'Ivysaur');
      const evolution2 = Evolution(pokeNum: '002', name: 'Ivysaur');
      const evolution3 = Evolution(pokeNum: '003', name: 'Venusaur');

      // Assert
      expect(evolution1, equals(evolution2));
      expect(evolution1, isNot(equals(evolution3)));
    });

    test('should have correct props', () {
      // Arrange
      const evolution = Evolution(pokeNum: '002', name: 'Ivysaur');

      // Assert
      expect(evolution.props, ['002', 'Ivysaur']);
    });
  });

  group('Pokemon', () {
    const tPokemon = Pokemon(
      id: 1,
      num: '001',
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
      nextEvolution: [Evolution(pokeNum: '002', name: 'Ivysaur')],
    );

    test('should support value equality', () {
      // Arrange
      const pokemon1 = Pokemon(
        id: 1,
        num: '001',
        name: 'Bulbasaur',
        img: 'http://www.serebii.net/pokemongo/pokemon/001.png',
        type: ['Grass', 'Poison'],
        height: '0.71 m',
        weight: '6.9 kg',
        candy: 'Bulbasaur Candy',
        egg: '2 km',
        spawnChance: 0.69,
        avgSpawns: 69,
        spawnTime: '20:00',
        weaknesses: ['Fire', 'Ice'],
      );

      const pokemon2 = Pokemon(
        id: 1,
        num: '001',
        name: 'Bulbasaur',
        img: 'http://www.serebii.net/pokemongo/pokemon/001.png',
        type: ['Grass', 'Poison'],
        height: '0.71 m',
        weight: '6.9 kg',
        candy: 'Bulbasaur Candy',
        egg: '2 km',
        spawnChance: 0.69,
        avgSpawns: 69,
        spawnTime: '20:00',
        weaknesses: ['Fire', 'Ice'],
      );

      const pokemon3 = Pokemon(
        id: 2,
        num: '002',
        name: 'Ivysaur',
        img: 'http://www.serebii.net/pokemongo/pokemon/002.png',
        type: ['Grass', 'Poison'],
        height: '0.99 m',
        weight: '13.0 kg',
        candy: 'Bulbasaur Candy',
        egg: 'Not in Eggs',
        spawnChance: 0.042,
        avgSpawns: 4.2,
        spawnTime: '07:00',
        weaknesses: ['Fire', 'Ice'],
      );

      // Assert
      expect(pokemon1, equals(pokemon2));
      expect(pokemon1, isNot(equals(pokemon3)));
    });

    test('should have all required properties', () {
      // Assert
      expect(tPokemon.id, 1);
      expect(tPokemon.num, '001');
      expect(tPokemon.name, 'Bulbasaur');
      expect(tPokemon.img, 'http://www.serebii.net/pokemongo/pokemon/001.png');
      expect(tPokemon.type, ['Grass', 'Poison']);
      expect(tPokemon.height, '0.71 m');
      expect(tPokemon.weight, '6.9 kg');
      expect(tPokemon.candy, 'Bulbasaur Candy');
      expect(tPokemon.candyCount, 25);
      expect(tPokemon.egg, '2 km');
      expect(tPokemon.spawnChance, 0.69);
      expect(tPokemon.avgSpawns, 69);
      expect(tPokemon.spawnTime, '20:00');
      expect(tPokemon.multipliers, [1.58]);
      expect(tPokemon.weaknesses, ['Fire', 'Ice', 'Flying', 'Psychic']);
      expect(tPokemon.nextEvolution, [
        const Evolution(pokeNum: '002', name: 'Ivysaur'),
      ]);
    });

    test('should handle optional properties as null', () {
      // Arrange
      const pokemonWithoutOptionals = Pokemon(
        id: 1,
        num: '001',
        name: 'Bulbasaur',
        img: 'http://www.serebii.net/pokemongo/pokemon/001.png',
        type: ['Grass', 'Poison'],
        height: '0.71 m',
        weight: '6.9 kg',
        candy: 'Bulbasaur Candy',
        egg: '2 km',
        spawnChance: 0.69,
        avgSpawns: 69,
        spawnTime: '20:00',
        weaknesses: ['Fire', 'Ice'],
      );

      // Assert
      expect(pokemonWithoutOptionals.candyCount, null);
      expect(pokemonWithoutOptionals.multipliers, null);
      expect(pokemonWithoutOptionals.nextEvolution, null);
      expect(pokemonWithoutOptionals.prevEvolution, null);
    });
  });
}
