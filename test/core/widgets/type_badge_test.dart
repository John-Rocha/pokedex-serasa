import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/utils/pokemon_type_colors.dart';
import 'package:pokedex_serasa/core/widgets/type_badge.dart';

void main() {
  Widget createWidgetUnderTest({
    String type = 'fire',
    double? fontSize,
    EdgeInsets? padding,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: TypeBadge(
          type: type,
          fontSize: fontSize ?? 12,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
    );
  }

  group('TypeBadge Widget Tests', () {
    testWidgets('should display type text in lowercase', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'FIRE'));

      expect(find.text('fire'), findsOneWidget);
    });

    testWidgets('should display icon for fire type', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire'));

      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('should display icon for water type', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'water'));

      expect(find.byIcon(Icons.water_drop), findsOneWidget);
    });

    testWidgets('should display icon for grass type', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'grass'));

      expect(find.byIcon(Icons.grass), findsOneWidget);
    });

    testWidgets('should display icon for electric type', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'electric'));

      expect(find.byIcon(Icons.electric_bolt), findsOneWidget);
    });

    testWidgets('should display icon for psychic type', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'psychic'));

      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });

    testWidgets('should display default icon for unknown type', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'unknown'));

      expect(find.byIcon(Icons.circle), findsOneWidget);
    });

    testWidgets('should display icon with white color', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire'));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.white);
    });

    testWidgets('should have correct background color for fire type',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire'));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, PokemonTypeColors.getTypeColor('fire'));
    });

    testWidgets('should have correct background color for water type',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'water'));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, PokemonTypeColors.getTypeColor('water'));
    });

    testWidgets('should have rounded border radius', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire'));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('should use custom font size when provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire', fontSize: 16));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 18);
    });

    testWidgets('should use default font size when not provided',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire'));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 14);
    });

    testWidgets('should use custom padding when provided', (tester) async {
      const customPadding = EdgeInsets.all(10);
      await tester.pumpWidget(
        createWidgetUnderTest(type: 'fire', padding: customPadding),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, customPadding);
    });

    testWidgets('should use default padding when not provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire'));

      final container = tester.widget<Container>(find.byType(Container));
      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      );
    });

    testWidgets('should have Row with min size', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(type: 'fire'));

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisSize, MainAxisSize.min);
    });
  });
}
