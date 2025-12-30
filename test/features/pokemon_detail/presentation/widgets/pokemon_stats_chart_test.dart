import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_stats_chart.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

void main() {
  group('PokemonStatsChart Widget Tests', () {
    const tPokemon = Pokemon(
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
      weaknesses: ['Fire', 'Ice', 'Flying', 'Psychic'],
      multipliers: [1.58],
    );

    const tPokemonWithoutMultipliers = Pokemon(
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

    Widget createWidgetUnderTest(Pokemon pokemon) {
      return MaterialApp(
        home: Scaffold(
          body: PokemonStatsChart(pokemon: pokemon),
        ),
      );
    }

    testWidgets('should display section title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      expect(find.text('Estatísticas'), findsOneWidget);
    });

    testWidgets('should display spawn chance stat', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      expect(find.text('Chance de Spawn'), findsOneWidget);
      expect(find.text('0.69%'), findsOneWidget);
    });

    testWidgets('should display average spawns stat', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      expect(find.text('Média de Spawns'), findsOneWidget);
      expect(find.text('69.0'), findsOneWidget);
    });

    testWidgets('should display multiplier when available', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      expect(find.text('Multiplicador'), findsOneWidget);
      expect(find.text('1.58'), findsOneWidget);
    });

    testWidgets('should not display multiplier when not available',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(tPokemonWithoutMultipliers),
      );

      expect(find.text('Multiplicador'), findsNothing);
    });

    testWidgets('should display LinearProgressIndicator for each stat',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      final progressIndicators = find.byType(LinearProgressIndicator);
      expect(progressIndicators, findsNWidgets(3));
    });

    testWidgets('should display progress indicators with correct values',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));
      await tester.pump();

      final progressIndicators =
          tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      final spawnChanceIndicator = progressIndicators.elementAt(0);
      expect(
        spawnChanceIndicator.value,
        closeTo(0.69 / 10.0, 0.01),
      );

      final avgSpawnsIndicator = progressIndicators.elementAt(1);
      expect(
        avgSpawnsIndicator.value,
        closeTo(69.0 / 100.0, 0.01),
      );

      final multiplierIndicator = progressIndicators.elementAt(2);
      expect(
        multiplierIndicator.value,
        closeTo(1.58 / 2.0, 0.01),
      );
    });

    testWidgets('should have grey background container', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(PokemonStatsChart),
              matching: find.byType(Container),
            )
            .last,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.grey[100]);
      expect(decoration.borderRadius, BorderRadius.circular(16));
    });

    testWidgets('should have padding around stats', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(PokemonStatsChart),
              matching: find.byType(Container),
            )
            .last,
      );

      expect(container.padding, const EdgeInsets.all(20));
    });

    testWidgets('should have rounded corners on progress bars',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      final clipRRects = tester.widgetList<ClipRRect>(
        find.byType(ClipRRect),
      );

      for (final clipRRect in clipRRects) {
        expect(clipRRect.borderRadius, BorderRadius.circular(8));
      }
    });

    testWidgets('should display stats in correct order', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      final statLabels = tester.widgetList<Text>(
        find.byType(Text),
      );

      final labels = statLabels.map((text) => text.data).toList();

      expect(labels.contains('Chance de Spawn'), isTrue);
      expect(labels.contains('Média de Spawns'), isTrue);
      expect(labels.contains('Multiplicador'), isTrue);

      final spawnChanceIndex = labels.indexOf('Chance de Spawn');
      final avgSpawnsIndex = labels.indexOf('Média de Spawns');
      final multiplierIndex = labels.indexOf('Multiplicador');

      expect(spawnChanceIndex < avgSpawnsIndex, isTrue);
      expect(avgSpawnsIndex < multiplierIndex, isTrue);
    });

    testWidgets('should have accessibility semantics', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('should display stats with zero spawn chance', (tester) async {
      const pokemonWithZeroSpawn = Pokemon(
        id: 150,
        num: '150',
        name: 'Mewtwo',
        img: 'http://test.png',
        type: ['Psychic'],
        height: '2.0 m',
        weight: '122.0 kg',
        candy: 'Mewtwo Candy',
        egg: 'Not in Eggs',
        spawnChance: 0.0,
        avgSpawns: 0.0,
        spawnTime: 'N/A',
        weaknesses: ['Bug', 'Ghost', 'Dark'],
      );

      await tester.pumpWidget(createWidgetUnderTest(pokemonWithZeroSpawn));

      expect(find.text('0.00%'), findsOneWidget);
      expect(find.text('0.0'), findsOneWidget);
    });

    testWidgets('should handle high spawn chance correctly', (tester) async {
      const pokemonWithHighSpawn = Pokemon(
        id: 16,
        num: '016',
        name: 'Pidgey',
        img: 'http://test.png',
        type: ['Normal', 'Flying'],
        height: '0.3 m',
        weight: '1.8 kg',
        candy: 'Pidgey Candy',
        candyCount: 12,
        egg: '2 km',
        spawnChance: 9.99,
        avgSpawns: 99.9,
        spawnTime: '01:23',
        weaknesses: ['Electric', 'Rock'],
        multipliers: [1.91],
      );

      await tester.pumpWidget(createWidgetUnderTest(pokemonWithHighSpawn));

      expect(find.text('9.99%'), findsOneWidget);
      expect(find.text('99.9'), findsOneWidget);
    });

    testWidgets('should normalize values correctly for progress bars',
        (tester) async {
      const pokemonWithExtremeValues = Pokemon(
        id: 143,
        num: '143',
        name: 'Snorlax',
        img: 'http://test.png',
        type: ['Normal'],
        height: '2.1 m',
        weight: '460.0 kg',
        candy: 'Snorlax Candy',
        egg: 'Not in Eggs',
        spawnChance: 15.0,
        avgSpawns: 150.0,
        spawnTime: '23:40',
        weaknesses: ['Fighting'],
        multipliers: [3.0],
      );

      await tester.pumpWidget(
        createWidgetUnderTest(pokemonWithExtremeValues),
      );
      await tester.pump();

      final progressIndicators =
          tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      for (final indicator in progressIndicators) {
        expect(indicator.value, lessThanOrEqualTo(1.0));
        expect(indicator.value, greaterThanOrEqualTo(0.0));
      }
    });

    testWidgets('should display column layout', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tPokemon));

      expect(
        find.descendant(
          of: find.byType(PokemonStatsChart),
          matching: find.byType(Column),
        ),
        findsWidgets,
      );
    });
  });
}
