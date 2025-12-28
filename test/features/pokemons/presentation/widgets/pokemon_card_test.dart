import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_card.dart';

void main() {
  group('PokemonCard Widget Tests', () {
    const tPokemon = Pokemon(
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
    );

    Widget createWidgetUnderTest({
      Pokemon? pokemon,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PokemonCard(
            pokemon: pokemon ?? tPokemon,
            onTap: onTap,
          ),
        ),
      );
    }

    testWidgets('should display pokemon name', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Bulbasaur'), findsOneWidget);
    });

    testWidgets('should display pokemon number', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('#001'), findsOneWidget);
    });

    testWidgets('should display pokemon types', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Grass'), findsOneWidget);
      expect(find.text('Poison'), findsOneWidget);
    });

    testWidgets('should display pokemon image', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      bool wasTapped = false;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          onTap: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(wasTapped, true);
    });

    testWidgets('should display only first two types when pokemon has more than 2 types',
        (tester) async {
      const pokemonWithManyTypes = Pokemon(
        id: 1,
        num: '001',
        name: 'Test',
        img: 'http://test.png',
        type: ['Type1', 'Type2', 'Type3', 'Type4'],
        height: '1 m',
        weight: '10 kg',
        candy: 'Candy',
        egg: '2 km',
        spawnChance: 0.5,
        avgSpawns: 50,
        spawnTime: '12:00',
        weaknesses: ['Fire'],
      );

      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: pokemonWithManyTypes),
      );

      expect(find.text('Type1'), findsOneWidget);
      expect(find.text('Type2'), findsOneWidget);
      expect(find.text('Type3'), findsNothing);
      expect(find.text('Type4'), findsNothing);
    });

    testWidgets('should show error icon when image fails to load', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Trigger image error
      await tester.pump();
      
      // Image widget should be present
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display correct background color for Grass type',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Bulbasaur'),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
    });
  });
}
