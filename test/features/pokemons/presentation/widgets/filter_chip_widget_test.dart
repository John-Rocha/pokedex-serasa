import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/filter_chip_widget.dart';

void main() {
  Widget buildWidget({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: FilterChipWidget(
          label: label,
          isActive: isActive,
          onTap: onTap,
          icon: icon,
        ),
      ),
    );
  }

  group('FilterChipWidget', () {
    testWidgets('should display label text', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Test Label',
          isActive: false,
          onTap: () {},
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('should have black background when active', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Active',
          isActive: true,
          onTap: () {},
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.black);
    });

    testWidgets('should have white background when inactive', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Inactive',
          isActive: false,
          onTap: () {},
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.white);
    });

    testWidgets('should have white text when active', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Active',
          isActive: true,
          onTap: () {},
        ),
      );

      final text = tester.widget<Text>(find.text('Active'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('should have black text when inactive', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Inactive',
          isActive: false,
          onTap: () {},
        ),
      );

      final text = tester.widget<Text>(find.text('Inactive'));
      expect(text.style?.color, Colors.black);
    });

    testWidgets('should show close icon when active and no custom icon',
        (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Active',
          isActive: true,
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should not show close icon when inactive', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Inactive',
          isActive: false,
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('should show custom icon when inactive and icon provided',
        (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'With Icon',
          isActive: false,
          onTap: () {},
          icon: Icons.filter_list,
        ),
      );

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should not show custom icon when active', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Active',
          isActive: true,
          onTap: () {},
          icon: Icons.filter_list,
        ),
      );

      expect(find.byIcon(Icons.filter_list), findsNothing);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildWidget(
          label: 'Tappable',
          isActive: false,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(FilterChipWidget));
      expect(tapped, true);
    });

    testWidgets('should have rounded corners', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Rounded',
          isActive: false,
          onTap: () {},
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, 20);
    });

    testWidgets('should have correct padding', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          label: 'Padded',
          isActive: false,
          onTap: () {},
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      );
    });
  });
}
