import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/error_display_widget.dart';

void main() {
  group('ErrorDisplayWidget Tests', () {
    const tErrorMessage = 'Network error occurred';

    Widget createWidgetUnderTest({
      String? message,
      VoidCallback? onRetry,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ErrorDisplayWidget(
            message: message ?? tErrorMessage,
            onRetry: onRetry,
          ),
        ),
      );
    }

    testWidgets('should display error title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Oops! Algo deu errado'), findsOneWidget);
    });

    testWidgets('should display error message', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(tErrorMessage), findsOneWidget);
    });

    testWidgets('should display error icon', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onRetry: () {}),
      );

      expect(find.text('Tentar Novamente'), findsOneWidget);
    });

    testWidgets('should NOT display retry button when onRetry is null',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onRetry: null),
      );

      expect(find.text('Tentar Novamente'), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('should call onRetry when retry button is tapped',
        (tester) async {
      bool retryWasCalled = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRetry: () => retryWasCalled = true,
        ),
      );

      await tester.tap(find.text('Tentar Novamente'));
      await tester.pump();

      expect(retryWasCalled, true);
    });

    testWidgets('should display custom error message', (tester) async {
      const customMessage = 'Custom error message';

      await tester.pumpWidget(
        createWidgetUnderTest(message: customMessage),
      );

      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('should display refresh icon in retry button', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(onRetry: () {}),
      );

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
