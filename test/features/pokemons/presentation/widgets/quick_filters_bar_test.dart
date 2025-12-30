import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/filter_chip_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/quick_filters_bar.dart';

void main() {
  Widget buildWidget({
    required SortOrder currentSortOrder,
    required VoidCallback onFiltersTap,
    required Function(SortOrder) onSortOrderChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: QuickFiltersBar(
          currentSortOrder: currentSortOrder,
          onFiltersTap: onFiltersTap,
          onSortOrderChanged: onSortOrderChanged,
        ),
      ),
    );
  }

  group('QuickFiltersBar', () {
    testWidgets('should display three filter chips', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      expect(find.byType(FilterChipWidget), findsNWidgets(3));
    });

    testWidgets('should display "Filtro" chip', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      expect(find.text('Filtro'), findsOneWidget);
    });

    testWidgets('should display "alfabética (A-Z)" chip', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      expect(find.text('alfabética (A-Z)'), findsOneWidget);
    });

    testWidgets('should display "código (crescente)" chip', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      expect(find.text('código (crescente)'), findsOneWidget);
    });

    testWidgets('should call onFiltersTap when filter chip is tapped',
        (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () => tapped = true,
          onSortOrderChanged: (_) {},
        ),
      );

      await tester.tap(find.text('Filtro'));
      expect(tapped, true);
    });

    testWidgets(
        'should call onSortOrderChanged with alphabetical when alphabetical chip is tapped',
        (tester) async {
      SortOrder? receivedSortOrder;

      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (order) => receivedSortOrder = order,
        ),
      );

      await tester.tap(find.text('alfabética (A-Z)'));
      expect(receivedSortOrder, SortOrder.alphabetical);
    });

    testWidgets(
        'should call onSortOrderChanged with none when alphabetical chip is tapped while active',
        (tester) async {
      SortOrder? receivedSortOrder;

      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.alphabetical,
          onFiltersTap: () {},
          onSortOrderChanged: (order) => receivedSortOrder = order,
        ),
      );

      await tester.tap(find.text('alfabética (A-Z)'));
      expect(receivedSortOrder, SortOrder.none);
    });

    testWidgets(
        'should call onSortOrderChanged with idDescending when code chip is tapped from none',
        (tester) async {
      SortOrder? receivedSortOrder;

      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (order) => receivedSortOrder = order,
        ),
      );

      await tester.tap(find.text('código (crescente)'));
      expect(receivedSortOrder, SortOrder.idDescending);
    });

    testWidgets(
        'should call onSortOrderChanged with none when code chip is tapped while idDescending',
        (tester) async {
      SortOrder? receivedSortOrder;

      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.idDescending,
          onFiltersTap: () {},
          onSortOrderChanged: (order) => receivedSortOrder = order,
        ),
      );

      await tester.tap(find.text('código (decrescente)'));
      expect(receivedSortOrder, SortOrder.none);
    });

    testWidgets('should display "código (decrescente)" when sort is idDescending',
        (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.idDescending,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      expect(find.text('código (decrescente)'), findsOneWidget);
    });

    testWidgets('should show alphabetical chip as active when sort is alphabetical',
        (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.alphabetical,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      final chips = tester.widgetList<FilterChipWidget>(
        find.byType(FilterChipWidget),
      );

      final alphabeticalChip = chips.firstWhere(
        (chip) => chip.label == 'alfabética (A-Z)',
      );

      expect(alphabeticalChip.isActive, true);
    });

    testWidgets('should show code chip as inactive when sort is none',
        (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      final chips = tester.widgetList<FilterChipWidget>(
        find.byType(FilterChipWidget),
      );

      final codeChip = chips.firstWhere(
        (chip) => chip.label == 'código (crescente)',
      );

      expect(codeChip.isActive, false);
    });

    testWidgets('should show code chip as active when sort is idDescending',
        (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.idDescending,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      final chips = tester.widgetList<FilterChipWidget>(
        find.byType(FilterChipWidget),
      );

      final codeChip = chips.firstWhere(
        (chip) => chip.label == 'código (decrescente)',
      );

      expect(codeChip.isActive, true);
    });

    testWidgets('should be horizontally scrollable', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          currentSortOrder: SortOrder.none,
          onFiltersTap: () {},
          onSortOrderChanged: (_) {},
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      expect(scrollView.scrollDirection, Axis.horizontal);
    });
  });
}
