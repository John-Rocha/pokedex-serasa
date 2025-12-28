import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/empty_search_widget.dart';

void main() {
  group('EmptySearchWidget Tests', () {
    const tQuery = 'Charizard';

    Widget createWidgetUnderTest({String? query}) {
      return MaterialApp(
        home: Scaffold(
          body: EmptySearchWidget(
            query: query ?? tQuery,
          ),
        ),
      );
    }

    testWidgets('should display empty search icon', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('should display empty search title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Nenhum Pokémon encontrado'), findsOneWidget);
    });

    testWidgets('should display query in message', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Charizard'), findsOneWidget);
    });

    testWidgets('should display helpful message', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(
        find.textContaining('Não encontramos resultados para'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Tente buscar por outro nome ou número'),
        findsOneWidget,
      );
    });

    testWidgets('should center content', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('should use SingleChildScrollView', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should use BouncingScrollPhysics', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      expect(scrollView.physics, isA<BouncingScrollPhysics>());
    });

    testWidgets('should display different query correctly', (tester) async {
      const customQuery = 'Mewtwo';

      await tester.pumpWidget(createWidgetUnderTest(query: customQuery));

      expect(find.textContaining(customQuery), findsOneWidget);
    });

    testWidgets('should have correct text alignment', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final titleText = tester.widget<Text>(
        find.text('Nenhum Pokémon encontrado'),
      );
      expect(titleText.textAlign, TextAlign.center);

      final messageTexts = tester.widgetList<Text>(
        find.textContaining('Não encontramos'),
      );
      for (final text in messageTexts) {
        expect(text.textAlign, TextAlign.center);
      }
    });

    testWidgets('should have grey colored icon', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final icon = tester.widget<Icon>(find.byIcon(Icons.search_off));
      expect(icon.color, isNotNull);
      expect(icon.size, 64);
    });
  });
}
