import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/advanced_filters_bottom_sheet.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/filter_chip_widget.dart';

void main() {
  Widget buildWidget({
    required SortOrder currentSortOrder,
    required String? selectedType,
    required List<String> availableTypes,
    required Function(SortOrder, String?) onApplyFilters,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => AdvancedFiltersBottomSheet(
            currentSortOrder: currentSortOrder,
            selectedType: selectedType,
            availableTypes: availableTypes,
            onApplyFilters: onApplyFilters,
          ),
        ),
      ),
    );
  }

  group('AdvancedFiltersBottomSheet', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      expect(find.text('Filtros avançados'), findsOneWidget);
    });

    testWidgets('should display clear button', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      expect(find.text('Limpar'), findsOneWidget);
    });

    testWidgets('should display apply filters button', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      expect(find.text('Aplicar Filtros'), findsOneWidget);
    });

    testWidgets('should display sort filter chips', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      expect(find.byType(FilterChipWidget), findsNWidgets(2));
      expect(find.text('alfabética (A-Z)'), findsOneWidget);
      expect(find.text('código (crescente)'), findsOneWidget);
    });

    testWidgets('should display type label and dropdown', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      expect(find.text('Tipo'), findsOneWidget);
      expect(
        find.byType(DropdownButtonFormField<String>),
        findsOneWidget,
      );
    });

    testWidgets('should display sort order label and dropdown', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      expect(find.text('Ordenar por'), findsOneWidget);
      expect(
        find.byType(DropdownButtonFormField<SortOrder>),
        findsOneWidget,
      );
    });

    testWidgets('should toggle alphabetical sort when chip is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      final alphabeticalChipFinder = find.ancestor(
        of: find.text('alfabética (A-Z)'),
        matching: find.byType(FilterChipWidget),
      );

      var chip = tester.widget<FilterChipWidget>(alphabeticalChipFinder);
      expect(chip.isActive, false);

      await tester.tap(alphabeticalChipFinder);
      await tester.pumpAndSettle();

      chip = tester.widget<FilterChipWidget>(alphabeticalChipFinder);
      expect(chip.isActive, true);
    });

    testWidgets('should toggle code sort when chip is tapped', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      final codeChipFinder = find.ancestor(
        of: find.text('código (crescente)'),
        matching: find.byType(FilterChipWidget),
      );

      var chip = tester.widget<FilterChipWidget>(codeChipFinder);
      expect(chip.isActive, false);

      await tester.tap(codeChipFinder);
      await tester.pumpAndSettle();

      chip = tester.widget<FilterChipWidget>(codeChipFinder);
      expect(chip.isActive, true);
    });

    testWidgets('should clear filters when clear button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.alphabetical,
          selectedType: 'Fire',
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle();

      final alphabeticalChip = tester.widget<FilterChipWidget>(
        find.ancestor(
          of: find.text('alfabética (A-Z)'),
          matching: find.byType(FilterChipWidget),
        ),
      );

      expect(alphabeticalChip.isActive, false);
    });

    testWidgets('should initialize with current sort order', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.alphabetical,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      final alphabeticalChip = tester.widget<FilterChipWidget>(
        find.ancestor(
          of: find.text('alfabética (A-Z)'),
          matching: find.byType(FilterChipWidget),
        ),
      );

      expect(alphabeticalChip.isActive, true);
    });

    testWidgets('should display available types in dropdown', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water', 'Grass'],
          onApplyFilters: (_, _) {},
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Todos'), findsWidgets);
      expect(find.text('Fire'), findsWidgets);
      expect(find.text('Water'), findsWidgets);
      expect(find.text('Grass'), findsWidgets);
    });

    testWidgets('should display all sort orders in dropdown', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<SortOrder>));
      await tester.pumpAndSettle();

      expect(find.text('Nenhum'), findsWidgets);
      expect(find.text('Alfabética (A-Z)'), findsWidgets);
      expect(find.text('Código (crescente)'), findsWidgets);
      expect(find.text('Código (decrescente)'), findsWidgets);
    });

    testWidgets('should show tune icon', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          selectedType: null,
          availableTypes: ['Fire', 'Water'],
          onApplyFilters: (_, _) {},
        ),
      );

      expect(find.byIcon(Icons.tune), findsOneWidget);
    });
  });
}
