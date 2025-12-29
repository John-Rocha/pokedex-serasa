import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_info_section.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

void main() {
  group('PokemonInfoSection Widget Tests', () {
    const tPokemonWithCandyCount = Pokemon(
      id: 1,
      num: '001',
      name: 'Bulbasaur',
      img: 'http://test.png',
      type: ['Grass', 'Poison'],
      height: '0.71 m',
      weight: '6.9 kg',
      candy: 'Bulbasaur Candy',
      candyCount: 25,
      egg: '2 km',
      spawnChance: 0.69,
      avgSpawns: 69,
      spawnTime: '20:00',
      weaknesses: ['Fire'],
    );

    const tPokemonWithoutCandyCount = Pokemon(
      id: 2,
      num: '002',
      name: 'Ivysaur',
      img: 'http://test.png',
      type: ['Grass', 'Poison'],
      height: '0.99 m',
      weight: '13.0 kg',
      candy: 'Bulbasaur Candy',
      egg: 'Not in Eggs',
      spawnChance: 0.042,
      avgSpawns: 4.2,
      spawnTime: '07:00',
      weaknesses: ['Fire'],
    );

    Widget createWidgetUnderTest(Pokemon pokemon) {
      return MaterialApp(
        home: Scaffold(
          body: PokemonInfoSection(pokemon: pokemon),
        ),
      );
    }

    testWidgets('should display section title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Informações'), findsOneWidget);
    });

    testWidgets('should display height label and value', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Altura'), findsOneWidget);
      expect(find.text('0.71 m'), findsOneWidget);
    });

    testWidgets('should display weight label and value', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Peso'), findsOneWidget);
      expect(find.text('6.9 kg'), findsOneWidget);
    });

    testWidgets('should display candy label and value', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Doce'), findsOneWidget);
      expect(find.text('Bulbasaur Candy'), findsOneWidget);
    });

    testWidgets('should display candy count when available', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Doces para evoluir'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('should not display candy count when not available',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithoutCandyCount));

      expect(find.text('Doces para evoluir'), findsNothing);
    });

    testWidgets('should display egg label and value', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Ovo'), findsOneWidget);
      expect(find.text('2 km'), findsOneWidget);
    });

    testWidgets('should display spawn chance label and formatted value',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Chance de spawn'), findsOneWidget);
      expect(find.text('0.69%'), findsOneWidget);
    });

    testWidgets('should display spawn time label and value', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Horário de spawn'), findsOneWidget);
      expect(find.text('20:00'), findsOneWidget);
    });

    testWidgets('should have grey background container', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      final containers = find.descendant(
        of: find.byType(PokemonInfoSection),
        matching: find.byType(Container),
      );

      final container = tester.widget<Container>(containers.first);
      final decoration = container.decoration as BoxDecoration?;

      expect(decoration?.color, Colors.grey[100]);
    });

    testWidgets('should have rounded border radius', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      final containers = find.descendant(
        of: find.byType(PokemonInfoSection),
        matching: find.byType(Container),
      );

      final container = tester.widget<Container>(containers.first);
      final decoration = container.decoration as BoxDecoration?;

      expect(decoration?.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('should display dividers between info rows', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('should format spawn chance with 2 decimal places',
        (tester) async {
      await tester
          .pumpWidget(createWidgetUnderTest(tPokemonWithoutCandyCount));

      expect(find.text('0.04%'), findsOneWidget);
    });

    testWidgets('should display all required information', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemonWithCandyCount));

      expect(find.text('Altura'), findsOneWidget);
      expect(find.text('Peso'), findsOneWidget);
      expect(find.text('Doce'), findsOneWidget);
      expect(find.text('Ovo'), findsOneWidget);
      expect(find.text('Chance de spawn'), findsOneWidget);
      expect(find.text('Horário de spawn'), findsOneWidget);
    });
  });
}
