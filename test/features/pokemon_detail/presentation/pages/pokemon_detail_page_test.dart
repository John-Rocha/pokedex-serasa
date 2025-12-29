import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/widgets/type_badge.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/pages/pokemon_detail_page.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_evolution_chain.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_info_section.dart';
import 'package:pokedex_serasa/features/pokemon_detail/presentation/widgets/pokemon_wikeness_widget.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_header_widget.dart';

import '../../../../helpers/test_module.dart';

void main() {
  group('PokemonDetailPage Widget Tests', () {
    const tPokemonWithEvolutions = Pokemon(
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
    );

    const tPokemonWithoutEvolutions = Pokemon(
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

    const tAllPokemons = [
      tPokemonWithEvolutions,
      tIvysaur,
      tVenusaur,
      tPokemonWithoutEvolutions,
    ];

    Widget createWidgetUnderTest({
      required Pokemon pokemon,
      List<Pokemon>? allPokemons,
    }) {
      return ModularApp(
        module: TestModule(),
        child: MaterialApp(
          home: PokemonDetailPage(
            pokemon: pokemon,
            allPokemons: allPokemons,
          ),
        ),
      );
    }

    testWidgets('should have Scaffold', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should use CustomScrollView', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should display PokemonHeaderWidget', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.byType(PokemonHeaderWidget), findsOneWidget);
    });

    testWidgets('should display pokemon name in header', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.text('Bulbasaur'), findsOneWidget);
    });

    testWidgets('should display pokemon number in header', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.text('#001'), findsOneWidget);
    });

    testWidgets('should display type badges for all types', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );
      await tester.pump();

      expect(find.text('grass'), findsOneWidget);
      expect(find.text('poison'), findsOneWidget);
    });

    testWidgets('should display PokemonWikenessWidget', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.byType(PokemonWikenessWidget), findsOneWidget);
    });

    testWidgets('should display PokemonInfoSection', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.byType(PokemonInfoSection), findsOneWidget);
    });

    testWidgets(
      'should display PokemonEvolutionChain when pokemon has evolutions',
      (tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            pokemon: tPokemonWithEvolutions,
            allPokemons: tAllPokemons,
          ),
        );

        expect(find.byType(PokemonEvolutionChain), findsOneWidget);
      },
    );

    testWidgets(
      'should not display PokemonEvolutionChain when pokemon has no evolutions',
      (tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            pokemon: tPokemonWithoutEvolutions,
            allPokemons: tAllPokemons,
          ),
        );

        expect(find.byType(PokemonEvolutionChain), findsNothing);
      },
    );

    testWidgets('should display all main sections', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          pokemon: tPokemonWithEvolutions,
          allPokemons: tAllPokemons,
        ),
      );

      expect(find.byType(PokemonHeaderWidget), findsOneWidget);
      expect(find.byType(PokemonWikenessWidget), findsOneWidget);
      expect(find.byType(PokemonInfoSection), findsOneWidget);
      expect(find.byType(PokemonEvolutionChain), findsOneWidget);
    });

    testWidgets('should use SliverToBoxAdapter for content', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      expect(find.byType(SliverToBoxAdapter), findsWidgets);
    });

    testWidgets('should have type badges in Wrap widget', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );
      await tester.pump();

      final wrap = tester.widget<Wrap>(
        find
            .descendant(
              of: find.byType(SliverToBoxAdapter),
              matching: find.byType(Wrap),
            )
            .first,
      );

      expect(wrap.spacing, 8);
      expect(wrap.runSpacing, 8);
    });

    testWidgets('should have padding around main content', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );

      final paddingWidgets = find.descendant(
        of: find.byType(SliverToBoxAdapter),
        matching: find.byType(Padding),
      );

      expect(paddingWidgets, findsWidgets);
    });

    testWidgets('should display correct number of type badges', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(pokemon: tPokemonWithEvolutions),
      );
      await tester.pump();

      expect(find.byType(TypeBadge), findsWidgets);
    });
  });
}
