import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/widgets/type_badge.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_wikeness_widget.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

void main() {
  group('PokemonWikenessWidget Widget Tests', () {
    const tPokemonWithMultipleWeaknesses = Pokemon(
      id: 1,
      pokeNum: '001',
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
      weaknesses: ['Fire', 'Ice', 'Flying', 'Psychic'],
    );

    const tPokemonWithSingleWeakness = Pokemon(
      id: 25,
      pokeNum: '025',
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

    const tPokemonWithNoWeaknesses = Pokemon(
      id: 26,
      pokeNum: '026',
      name: 'Raichu',
      img: 'http://test.png',
      type: ['Electric'],
      height: '0.8 m',
      weight: '30.0 kg',
      candy: 'Pikachu Candy',
      egg: 'Not in Eggs',
      spawnChance: 0.0076,
      avgSpawns: 0.76,
      spawnTime: '00:30',
      weaknesses: [],
    );

    Widget createWidgetUnderTest(Pokemon pokemon) {
      return MaterialApp(
        home: Scaffold(
          body: PokemonWikenessWidget(pokemon: pokemon),
        ),
      );
    }

    testWidgets('should display section title', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithMultipleWeaknesses),
      );

      expect(find.text('Fraquezas'), findsOneWidget);
    });

    testWidgets('should display type badges for all weaknesses', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithMultipleWeaknesses),
      );

      expect(find.byType(TypeBadge), findsNWidgets(4));
    });

    testWidgets('should display type badges for single weakness', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithSingleWeakness),
      );

      expect(find.byType(TypeBadge), findsOneWidget);
    });

    testWidgets('should not display type badges when no weaknesses', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithNoWeaknesses));

      expect(find.byType(TypeBadge), findsNothing);
    });

    testWidgets('should display correct weakness types', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithMultipleWeaknesses),
      );

      expect(find.text('fire'), findsOneWidget);
      expect(find.text('ice'), findsOneWidget);
      expect(find.text('flying'), findsOneWidget);
      expect(find.text('psychic'), findsOneWidget);
    });

    testWidgets('should use horizontal scroll view', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithMultipleWeaknesses),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets('should have padding between badges', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithMultipleWeaknesses),
      );

      final paddingWidgets = find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byType(Padding),
      );

      expect(paddingWidgets, findsWidgets);
    });

    testWidgets('should have Column as main container', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithMultipleWeaknesses),
      );

      final column = tester.widget<Column>(
        find
            .descendant(
              of: find.byType(PokemonWikenessWidget),
              matching: find.byType(Column),
            )
            .first,
      );

      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should contain Row inside ScrollView', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithMultipleWeaknesses),
      );

      expect(
        find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Row),
        ),
        findsWidgets,
      );
    });
  });
}
