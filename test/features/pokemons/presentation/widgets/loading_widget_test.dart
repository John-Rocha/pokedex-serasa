import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/core/theme/app_colors.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/loading_widget.dart';

void main() {
  group('LoadingWidget Tests', () {
    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: Scaffold(
          body: LoadingWidget(),
        ),
      );
    }

    testWidgets('should display CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should center the progress indicator', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should use primary red color for progress indicator',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      final valueColor = progressIndicator.valueColor as AlwaysStoppedAnimation<Color>;
      expect(valueColor.value, AppColors.primaryRed);
    });

    testWidgets('should be visible and not have zero size', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);

      final size = tester.getSize(progressIndicatorFinder);
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
    });
  });
}
