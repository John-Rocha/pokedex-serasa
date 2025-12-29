import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_evolution_chain.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_card.dart';

void main() {
  group('PokemonEvolutionChain Widget Tests', () {
    const tBulbasaur = Pokemon(
      id: 1,
      num: '001',
      name: 'Bulbasaur',
      img: 'http://test.png',
      type: ['Grass', 'Poison'],
      height: '0.71 m',
      weight: '6.9 kg',
      candy: 'Bulbasaur Candy',
      egg: '2 km',
      spawnChance: 0.69,
      avgSpawns: 69,
      spawnTime: '20:00',
      weaknesses: ['Fire'],
      nextEvolution: [
        Evolution(num: '002', name: 'Ivysaur'),
        Evolution(num: '003', name: 'Venusaur'),
      ],
    );

    const tIvysaur = Pokemon(
      id: 2,
      num: '002',
      name: 'Ivysaur',
      img: 'http://test2.png',
      type: ['Grass', 'Poison'],
      height: '0.99 m',
      weight: '13.0 kg',
      candy: 'Bulbasaur Candy',
      egg: 'Not in Eggs',
      spawnChance: 0.042,
      avgSpawns: 4.2,
      spawnTime: '07:00',
      weaknesses: ['Fire'],
      prevEvolution: [
        Evolution(num: '001', name: 'Bulbasaur'),
      ],
      nextEvolution: [
        Evolution(num: '003', name: 'Venusaur'),
      ],
    );

    const tVenusaur = Pokemon(
      id: 3,
      num: '003',
      name: 'Venusaur',
      img: 'http://test3.png',
      type: ['Grass', 'Poison'],
      height: '2.01 m',
      weight: '100.0 kg',
      candy: 'Bulbasaur Candy',
      egg: 'Not in Eggs',
      spawnChance: 0.017,
      avgSpawns: 1.7,
      spawnTime: '11:30',
      weaknesses: ['Fire'],
      prevEvolution: [
        Evolution(num: '001', name: 'Bulbasaur'),
        Evolution(num: '002', name: 'Ivysaur'),
      ],
    );

    const tPikachu = Pokemon(
      id: 25,
      num: '025',
      name: 'Pikachu',
      img: 'http://test.png',
      type: ['Electric'],
      height: '0.4 m',
      weight: '6.0 kg',
      candy: 'Pikachu Candy',
      egg: '2 km',
      spawnChance: 0.21,
      avgSpawns: 21,
      spawnTime: '04:00',
      weaknesses: ['Ground'],
    );

    const tAllPokemons = [tBulbasaur, tIvysaur, tVenusaur, tPikachu];

    Widget createWidgetUnderTest({
      required Pokemon pokemon,
      List<Pokemon>? allPokemons,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PokemonEvolutionChain(
            pokemon: pokemon,
            allPokemons: allPokemons,
          ),
        ),
      );
    }

    testWidgets('should display section title when pokemon has evolutions',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tBulbasaur,
          allPokemons: tAllPokemons,
        ),
      );

      expect(find.text('Relacionados'), findsOneWidget);
    });

    testWidgets('should not display anything when pokemon has no evolutions',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tPikachu,
          allPokemons: tAllPokemons,
        ),
      );

      expect(find.text('Relacionados'), findsNothing);
      expect(find.byType(PokemonCard), findsNothing);
    });

    testWidgets('should display PokemonCards for next evolutions',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tBulbasaur,
          allPokemons: tAllPokemons,
        ),
      );
      await tester.pump();

      expect(find.byType(PokemonCard), findsNWidgets(2));
      expect(find.text('Ivysaur'), findsOneWidget);
      expect(find.text('Venusaur'), findsOneWidget);
    });

    testWidgets('should display PokemonCards for previous evolutions',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tVenusaur,
          allPokemons: tAllPokemons,
        ),
      );
      await tester.pump();

      expect(find.byType(PokemonCard), findsNWidgets(2));
      expect(find.text('Bulbasaur'), findsOneWidget);
      expect(find.text('Ivysaur'), findsOneWidget);
    });

    testWidgets('should display both prev and next evolutions', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tIvysaur,
          allPokemons: tAllPokemons,
        ),
      );
      await tester.pump();

      expect(find.byType(PokemonCard), findsNWidgets(2));
      expect(find.text('Bulbasaur'), findsOneWidget);
      expect(find.text('Venusaur'), findsOneWidget);
    });

    testWidgets('should not display cards when allPokemons is null',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tBulbasaur,
          allPokemons: null,
        ),
      );

      expect(find.byType(PokemonCard), findsNothing);
    });

    testWidgets('should use Column as main container', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tBulbasaur,
          allPokemons: tAllPokemons,
        ),
      );

      final column = tester.widget<Column>(
        find.byType(Column).first,
      );

      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      expect(column.mainAxisSize, MainAxisSize.min);
    });

    testWidgets('should center evolution cards in Row', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tBulbasaur,
          allPokemons: tAllPokemons,
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });
  });
}
