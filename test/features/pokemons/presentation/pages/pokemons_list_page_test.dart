import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/pages/pokemons_list_page.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/error_display_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/loading_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_card.dart';

class MockPokemonsListCubit extends Mock implements PokemonsListCubit {}

class MockModule extends Module {
  final PokemonsListCubit cubit;

  MockModule(this.cubit);

  @override
  void binds(i) {
    i.addInstance<PokemonsListCubit>(cubit);
  }
}

void main() {
  late MockPokemonsListCubit mockCubit;

  setUp(() {
    mockCubit = MockPokemonsListCubit();
  });

  group('PokemonsListPage Widget Tests', () {
    const tPokemons = [
      Pokemon(
        id: 1,
        num: '001',
        name: 'Bulbasaur',
        img: 'http://test.png',
        type: ['Grass', 'Poison'],
        height: '0.71 m',
        weight: '6.9 kg',
        candy: 'Candy',
        egg: '2 km',
        spawnChance: 0.69,
        avgSpawns: 69,
        spawnTime: '20:00',
        weaknesses: ['Fire'],
      ),
      Pokemon(
        id: 2,
        num: '002',
        name: 'Ivysaur',
        img: 'http://test2.png',
        type: ['Grass', 'Poison'],
        height: '0.99 m',
        weight: '13.0 kg',
        candy: 'Candy',
        egg: 'Not in Eggs',
        spawnChance: 0.042,
        avgSpawns: 4.2,
        spawnTime: '07:00',
        weaknesses: ['Fire'],
      ),
    ];

    Widget createWidgetUnderTest() {
      return ModularApp(
        module: MockModule(mockCubit),
        child: const MaterialApp(
          home: PokemonsListPage(),
        ),
      );
    }

    testWidgets('should display loading widget when state is loading',
        (tester) async {
      when(() => mockCubit.state).thenReturn(const PokemonsListLoading());
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('should display error widget when state is error',
        (tester) async {
      const errorMessage = 'Network error';
      when(() => mockCubit.state)
          .thenReturn(const PokemonsListError(message: errorMessage));
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display pokemon grid when state is success',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(const PokemonsListSuccess(pokemons: tPokemons));
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(PokemonCard), findsNWidgets(2));
      expect(find.text('Bulbasaur'), findsOneWidget);
      expect(find.text('Ivysaur'), findsOneWidget);
    });

    testWidgets('should call loadPokemons on init', (tester) async {
      when(() => mockCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      verify(() => mockCubit.loadPokemons()).called(1);
    });

    testWidgets('should use CustomScrollView', (tester) async {
      when(() => mockCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should use BouncingScrollPhysics', (tester) async {
      when(() => mockCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );

      expect(scrollView.physics, isA<BouncingScrollPhysics>());
    });

    testWidgets('should display grid with 2 columns', (tester) async {
      when(() => mockCubit.state)
          .thenReturn(const PokemonsListSuccess(pokemons: tPokemons));
      when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final grid = tester.widget<SliverGrid>(
        find.byType(SliverGrid),
      );

      final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });
  });
}
