import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_search_field.dart';

void main() {
  group('PokemonSearchField Widget Tests', () {
    Widget createWidgetUnderTest({
      required Function(String) onSearch,
      VoidCallback? onClear,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PokemonSearchField(
            onSearch: onSearch,
            onClear: onClear,
          ),
        ),
      );
    }

    testWidgets('should display search hint text', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      expect(
        find.text('Buscar Pokémon por nome ou número'),
        findsOneWidget,
      );
    });

    testWidgets('should display search icon', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should NOT display clear button initially', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should display clear button when text is entered', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      await tester.enterText(
        find.byType(TextField),
        'Pikachu',
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should call onSearch with debounce when text changes', (
      tester,
    ) async {
      String? searchedQuery;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onSearch: (query) => searchedQuery = query,
        ),
      );

      await tester.enterText(find.byType(TextField), 'Bulbasaur');
      await tester.pump();

      // Debounce hasn't triggered yet
      expect(searchedQuery, null);

      // Wait for debounce (500ms)
      await tester.pump(const Duration(milliseconds: 500));

      expect(searchedQuery, 'Bulbasaur');
    });

    testWidgets('should clear text and call onSearch when clear is tapped', (
      tester,
    ) async {
      String? searchedQuery;
      bool clearWasCalled = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onSearch: (query) => searchedQuery = query,
          onClear: () => clearWasCalled = true,
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'Pikachu');
      await tester.pumpAndSettle();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('Pikachu'), findsNothing);
      expect(searchedQuery, '');
      expect(clearWasCalled, true);
    });

    testWidgets('should accept text input', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      await tester.enterText(find.byType(TextField), 'Charizard');
      await tester.pump();

      expect(find.text('Charizard'), findsOneWidget);
    });

    testWidgets('should handle multiple rapid text changes with debounce', (
      tester,
    ) async {
      final searchQueries = <String>[];

      await tester.pumpWidget(
        createWidgetUnderTest(
          onSearch: (query) => searchQueries.add(query),
        ),
      );

      // Rapid typing
      await tester.enterText(find.byType(TextField), 'P');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(TextField), 'Pi');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(TextField), 'Pik');
      await tester.pump(const Duration(milliseconds: 100));

      await tester.enterText(find.byType(TextField), 'Pika');
      await tester.pump(const Duration(milliseconds: 500));

      // Only the last query should be processed
      expect(searchQueries.length, 1);
      expect(searchQueries.last, 'Pika');
    });

    testWidgets('should display TextField with correct styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.decoration?.filled, true);
      expect(textField.decoration?.fillColor, Colors.white);
    });

    testWidgets('should have rounded corners decoration', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.byType(TextField),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should have shadow on container', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onSearch: (_) {}),
      );

      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.byType(TextField),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, greaterThan(0));
    });
  });
}
