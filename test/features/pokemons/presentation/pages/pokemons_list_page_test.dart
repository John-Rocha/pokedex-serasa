import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_event_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_filter_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_pokemon_view_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_screen_view_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_search_usecase.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_state.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/pages/pokemons_list_page.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/empty_search_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/error_display_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/loading_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_card.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_header_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_search_field.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemons_grid_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/quick_filters_bar.dart';

class MockPokemonsListCubit extends Mock implements PokemonsListCubit {}

class MockPokemonSearchCubit extends Mock implements PokemonSearchCubit {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class MockModule extends Module {
  final PokemonsListCubit listCubit;
  final PokemonSearchCubit searchCubit;

  MockModule({
    required this.listCubit,
    required this.searchCubit,
  });

  @override
  void binds(i) {
    i.addInstance<PokemonsListCubit>(listCubit);
    i.addInstance<PokemonSearchCubit>(searchCubit);

    final mockRepository = MockAnalyticsRepository();

    when(
      () => mockRepository.logScreenView(
        any(),
        any(),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logPokemonView(
        any(),
        any(),
        types: any(named: 'types'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logSearch(
        any(),
        resultsCount: any(named: 'resultsCount'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(
      () => mockRepository.logFilterApplied(
        any(),
        sortBy: any(named: 'sortBy'),
      ),
    ).thenAnswer((_) async => Future.value());

    i.addSingleton<AnalyticsRepository>(() => mockRepository);
    i.addSingleton(() => LogEventUseCase(repository: i.get()));
    i.addSingleton(() => LogFilterUseCase(repository: i.get()));
    i.addSingleton(() => LogPokemonViewUseCase(repository: i.get()));
    i.addSingleton(() => LogScreenViewUseCase(repository: i.get()));
    i.addSingleton(() => LogSearchUseCase(repository: i.get()));
  }
}

void main() {
  late MockPokemonsListCubit mockListCubit;
  late MockPokemonSearchCubit mockSearchCubit;

  setUp(() {
    mockListCubit = MockPokemonsListCubit();
    mockSearchCubit = MockPokemonSearchCubit();
  });

  group('PokemonsListPage Widget Tests', () {
    const tPokemons = [
      Pokemon(
        id: 1,
        pokeNum: '001',
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
        pokeNum: '002',
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
        module: MockModule(
          listCubit: mockListCubit,
          searchCubit: mockSearchCubit,
        ),
        child: const MaterialApp(
          home: PokemonsListPage(),
        ),
      );
    }

    testWidgets('should display PokemonSearchField', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonSearchField), findsOneWidget);
    });

    testWidgets('should display loading widget when list state is loading', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListLoading());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('should display pokemon grid when list state is success', (
      tester,
    ) async {
      when(
        () => mockListCubit.state,
      ).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonCard), findsNWidgets(2));
      expect(find.text('Bulbasaur'), findsOneWidget);
      expect(find.text('Ivysaur'), findsOneWidget);
    });

    testWidgets('should display error widget when list state is error', (
      tester,
    ) async {
      const errorMessage = 'Network error';
      when(
        () => mockListCubit.state,
      ).thenReturn(const PokemonsListError(message: errorMessage));
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should call loadPokemons on init', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      verify(() => mockListCubit.loadPokemons()).called(1);
    });

    testWidgets('should display search results when searching', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(() => mockSearchCubit.stream).thenAnswer(
        (_) => Stream.value(
          PokemonSearchSuccess(pokemons: [tPokemons[0]]),
        ),
      );
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Simulate search
      await tester.enterText(
        find.byType(TextField),
        'Bulbasaur',
      );
      await tester.pump(const Duration(milliseconds: 500));

      when(() => mockSearchCubit.state).thenReturn(
        PokemonSearchSuccess(pokemons: [tPokemons[0]]),
      );

      await tester.pump();
    });

    testWidgets('should display empty search widget when no results', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(() => mockSearchCubit.stream).thenAnswer(
        (_) => Stream.value(
          const PokemonSearchEmpty(query: 'Charizard'),
        ),
      );
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Simulate search
      await tester.enterText(
        find.byType(TextField),
        'Charizard',
      );
      await tester.pump(const Duration(milliseconds: 500));

      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchEmpty(query: 'Charizard'));

      await tester.pump();

      expect(find.byType(EmptySearchWidget), findsOneWidget);
    });

    testWidgets('should use CustomScrollView', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should use BouncingScrollPhysics', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );

      expect(scrollView.physics, isA<BouncingScrollPhysics>());
    });

    testWidgets('should display search loading widget when searching', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => Stream.value(const PokemonSearchLoading()));
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Bulbasaur');
      await tester.pump(const Duration(milliseconds: 500));

      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchLoading());

      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('should display search error widget when search fails', (
      tester,
    ) async {
      const errorMessage = 'Search failed';
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer(
        (_) => Stream.value(const PokemonSearchError(message: errorMessage)),
      );
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump(const Duration(milliseconds: 500));

      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchError(message: errorMessage));

      await tester.pump();

      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display initial search message', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => Stream.value(const PokemonSearchInitial()));
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(const Duration(milliseconds: 500));

      when(() => mockSearchCubit.state).thenReturn(
        const PokemonSearchInitial(),
      );
      await tester.pump();

      expect(find.text('Digite para buscar'), findsOneWidget);
    });

    testWidgets('should display initial state correctly', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(PokemonSearchField), findsOneWidget);
    });

    testWidgets('should display QuickFiltersBar', (tester) async {
      when(
        () => mockListCubit.state,
      ).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(QuickFiltersBar), findsOneWidget);
    });

    testWidgets('should display QuickFiltersBar with list state', (
      tester,
    ) async {
      when(
        () => mockListCubit.state,
      ).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(QuickFiltersBar), findsOneWidget);
    });

    testWidgets('should display QuickFiltersBar during search', (tester) async {
      when(
        () => mockListCubit.state,
      ).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer(
        (_) => Stream.value(PokemonSearchSuccess(pokemons: [tPokemons[0]])),
      );
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Bulbasaur');
      await tester.pump(const Duration(milliseconds: 500));

      when(
        () => mockSearchCubit.state,
      ).thenReturn(PokemonSearchSuccess(pokemons: [tPokemons[0]]));

      await tester.pump();

      expect(find.byType(QuickFiltersBar), findsOneWidget);
    });

    testWidgets('should have extendBodyBehindAppBar enabled', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.extendBodyBehindAppBar, true);
    });

    testWidgets('should display search results with multiple pokemons', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer(
        (_) => Stream.value(const PokemonSearchSuccess(pokemons: tPokemons)),
      );
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Bulba');
      await tester.pump(const Duration(milliseconds: 500));

      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchSuccess(pokemons: tPokemons));

      await tester.pump();

      expect(find.byType(PokemonCard), findsNWidgets(2));
    });

    testWidgets('should display initial list state loading', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('should display pokemon cards when list cubit emits success', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonCard), findsNWidgets(2));
    });

    testWidgets('should update to error state when list cubit emits error', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListLoading());
      when(() => mockListCubit.stream).thenAnswer(
        (_) => Stream.value(
          const PokemonsListError(message: 'Failed to load'),
        ),
      );
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.pump();

      expect(find.byType(ErrorDisplayWidget), findsOneWidget);
      expect(find.text('Failed to load'), findsOneWidget);
    });

    testWidgets('should have scroll controller attached', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );

      expect(scrollView.controller, isNotNull);
    });

    testWidgets('should display pokemon header widget', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Pokédex'), findsOneWidget);
    });

    testWidgets('should switch between list and search content', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => Stream.value(const PokemonSearchInitial()));
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});
      when(() => mockSearchCubit.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonCard), findsNWidgets(2));

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump(const Duration(milliseconds: 500));

      when(() => mockSearchCubit.state).thenReturn(
        const PokemonSearchInitial(),
      );
      await tester.pump();

      expect(find.text('Digite para buscar'), findsOneWidget);
    });

    testWidgets('should display SliverToBoxAdapter for filters', (
      tester,
    ) async {
      when(
        () => mockListCubit.state,
      ).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(SliverToBoxAdapter), findsWidgets);
    });

    testWidgets('should close cubits on dispose', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.pumpWidget(const SizedBox());

      verify(() => mockListCubit.close()).called(1);
      verify(() => mockSearchCubit.close()).called(1);
    });

    testWidgets('should display error message in error state', (tester) async {
      const errorMessage = 'Failed to load pokemons';
      when(() => mockListCubit.state).thenReturn(
        const PokemonsListError(message: errorMessage),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display empty list with success state', (tester) async {
      when(() => mockListCubit.state).thenReturn(
        const PokemonsListSuccess(pokemons: [], allPokemons: []),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonCard), findsNothing);
    });

    testWidgets('should display single pokemon card', (tester) async {
      when(() => mockListCubit.state).thenReturn(
        PokemonsListSuccess(
          pokemons: [tPokemons.first],
          allPokemons: [tPokemons.first],
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonCard), findsOneWidget);
    });

    testWidgets('should use BouncingScrollPhysics on scroll view', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );

      expect(scrollView.physics, isA<BouncingScrollPhysics>());
    });

    testWidgets('should display PokemonGridWidget in success state', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(PokemonGridWidget), findsOneWidget);
    });

    testWidgets('should have proper widget structure with sliver widgets', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(PokemonHeaderWidget), findsOneWidget);
    });

    testWidgets('should maintain scroll controller throughout lifecycle', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );

      expect(scrollView.controller, isNotNull);
    });

    testWidgets('should display all pokemons in success state', (tester) async {
      when(() => mockListCubit.state).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Bulbasaur'), findsOneWidget);
      expect(find.text('Ivysaur'), findsOneWidget);
    });

    testWidgets('should have multiple SliverToBoxAdapters', (tester) async {
      when(() => mockListCubit.state).thenReturn(
        const PokemonsListSuccess(
          pokemons: tPokemons,
          allPokemons: tPokemons,
        ),
      );
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(SliverToBoxAdapter), findsWidgets);
    });

    testWidgets('should have proper scaffold structure', (tester) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.extendBodyBehindAppBar, isTrue);
    });

    testWidgets('should have TextField with correct configuration', (
      tester,
    ) async {
      when(() => mockListCubit.state).thenReturn(const PokemonsListInitial());
      when(() => mockListCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => mockListCubit.loadPokemons()).thenAnswer((_) async {});
      when(() => mockListCubit.close()).thenAnswer((_) async {});
      when(
        () => mockSearchCubit.state,
      ).thenReturn(const PokemonSearchInitial());
      when(
        () => mockSearchCubit.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mockSearchCubit.close()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
