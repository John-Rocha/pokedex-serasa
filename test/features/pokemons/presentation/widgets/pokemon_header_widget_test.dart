import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_header_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_search_field.dart';

void main() {
  Widget buildWidget({
    required Function(String) onSearch,
    VoidCallback? onClearSearch,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            PokemonHeaderWidget(
              onSearch: onSearch,
              onClearSearch: onClearSearch,
            ),
          ],
        ),
      ),
    );
  }

  group('PokemonHeaderWidget', () {
    testWidgets('should display Pokédex title', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      expect(find.text('Pokédex'), findsOneWidget);
    });

    testWidgets('should display description text', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      expect(
        find.text('Explore o incrível mundo dos Pokémon.'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Descubra informações detalhadas sobre seus personagens favoritos.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display pokemon counter', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      expect(find.text('+1000k'), findsOneWidget);
      expect(find.text('Pokémons'), findsOneWidget);
    });

    testWidgets('should display search field', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      expect(find.byType(PokemonSearchField), findsOneWidget);
    });

    testWidgets('should be a SliverAppBar', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('should pass onSearch callback to search field',
        (tester) async {
      String? searchQuery;

      await tester.pumpWidget(
        buildWidget(
          onSearch: (query) => searchQuery = query,
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Pikachu',
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(searchQuery, 'Pikachu');
    });

    testWidgets('should have expandedHeight', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );

      expect(sliverAppBar.expandedHeight, isNotNull);
    });

    testWidgets('should be pinned', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );

      expect(sliverAppBar.pinned, true);
    });

    testWidgets('should have white background color', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );

      expect(sliverAppBar.backgroundColor, Colors.white);
    });

    testWidgets('should have FlexibleSpaceBar', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          onSearch: (_) {},
        ),
      );

      expect(find.byType(FlexibleSpaceBar), findsOneWidget);
    });
  });
}
