import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/core/utils/pokemon_types_helper.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_filter_usecase.dart';
import 'package:pokedex_serasa/features/analytics/domain/usecases/log_search_usecase.dart';
import 'package:pokedex_serasa/features/analytics/presentation/mixins/analytics_mixin.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemon_search/pokemon_search_state.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_cubit.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/cubits/pokemons_list/pokemons_list_state.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/advanced_filters_bottom_sheet.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/empty_search_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/error_display_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_header_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/quick_filters_bar.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/loading_widget.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemons_grid_widget.dart';

class PokemonsListPage extends StatefulWidget {
  const PokemonsListPage({super.key});

  @override
  State<PokemonsListPage> createState() => _PokemonsListPageState();
}

class _PokemonsListPageState extends State<PokemonsListPage>
    with AnalyticsMixin {
  @override
  String get screenName => 'Pokemon List';

  final PokemonsListCubit _listCubit = Modular.get<PokemonsListCubit>();
  final PokemonSearchCubit _searchCubit = Modular.get<PokemonSearchCubit>();
  final LogSearchUseCase _logSearchUseCase = Modular.get<LogSearchUseCase>();
  final LogFilterUseCase _logFilterUseCase = Modular.get<LogFilterUseCase>();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  bool _showFiltersBar = true;
  List<String> _availableTypes = [];

  @override
  void initState() {
    super.initState();
    _listCubit.loadPokemons();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _listCubit.close();
    _searchCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset > 100 && _showFiltersBar) {
        setState(() {
          _showFiltersBar = false;
        });
      } else if (_scrollController.offset <= 100 && !_showFiltersBar) {
        setState(() {
          _showFiltersBar = true;
        });
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isEmpty) {
      _searchCubit.clear();
    } else {
      _searchCubit.search(query);
      _searchCubit.stream.first.then((state) {
        if (state is PokemonSearchSuccess) {
          _logSearchUseCase(
            searchTerm: query,
            resultsCount: state.pokemons.length,
          );
        } else if (state is PokemonSearchEmpty) {
          _logSearchUseCase(
            searchTerm: query,
            resultsCount: 0,
          );
        }
      });
    }
  }

  void _onClearSearch() {
    setState(() {
      _isSearching = false;
    });
  }

  void _onSortOrderChanged(SortOrder sortOrder) {
    if (_isSearching) {
      _searchCubit.applySortOrder(sortOrder);
    } else {
      _listCubit.applySortOrder(sortOrder);
    }
  }

  void _showAdvancedFilters() {
    if (_listCubit.state is PokemonsListSuccess) {
      final state = _listCubit.state as PokemonsListSuccess;
      _availableTypes = PokemonTypesHelper.extractUniqueTypes(
        state.allPokemons,
      );
    }

    final currentSortOrder = _isSearching
        ? _searchCubit.currentSortOrder
        : _listCubit.currentSortOrder;
    final currentTypeFilter = _isSearching
        ? _searchCubit.currentTypeFilter
        : _listCubit.currentTypeFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedFiltersBottomSheet(
        currentSortOrder: currentSortOrder,
        selectedType: currentTypeFilter,
        availableTypes: _availableTypes,
        onApplyFilters: (sortOrder, typeFilter) {
          if (_isSearching) {
            _searchCubit.applyFilters(sortOrder, typeFilter);
          } else {
            _listCubit.applyFilters(sortOrder, typeFilter);
          }

          _logFilterUseCase(
            types: typeFilter != null ? [typeFilter] : [],
            sortBy: sortOrder.name != 'none' ? sortOrder.name : null,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          PokemonHeaderWidget(
            onSearch: _onSearch,
            onClearSearch: _onClearSearch,
          ),

          if (_showFiltersBar)
            SliverToBoxAdapter(
              child: _isSearching
                  ? BlocBuilder<PokemonSearchCubit, PokemonSearchState>(
                      bloc: _searchCubit,
                      builder: (context, state) {
                        final currentSort = state is PokemonSearchSuccess
                            ? state.sortOrder
                            : SortOrder.none;

                        return QuickFiltersBar(
                          currentSortOrder: currentSort,
                          onFiltersTap: _showAdvancedFilters,
                          onSortOrderChanged: _onSortOrderChanged,
                        );
                      },
                    )
                  : BlocBuilder<PokemonsListCubit, PokemonsListState>(
                      bloc: _listCubit,
                      builder: (context, state) {
                        final currentSort = state is PokemonsListSuccess
                            ? state.sortOrder
                            : SortOrder.none;

                        return QuickFiltersBar(
                          currentSortOrder: currentSort,
                          onFiltersTap: _showAdvancedFilters,
                          onSortOrderChanged: _onSortOrderChanged,
                        );
                      },
                    ),
            ),

          if (_isSearching)
            _PokemonSearchContent(
              searchCubit: _searchCubit,
              listCubit: _listCubit,
            )
          else
            _PokemonListContent(
              listCubit: _listCubit,
              onRetry: () => _listCubit.loadPokemons(),
            ),
        ],
      ),
    );
  }
}

class _PokemonSearchContent extends StatelessWidget {
  final PokemonSearchCubit searchCubit;
  final PokemonsListCubit _listCubit;

  const _PokemonSearchContent({
    required this.searchCubit,
    required PokemonsListCubit listCubit,
  }) : _listCubit = listCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonSearchCubit, PokemonSearchState>(
      bloc: searchCubit,
      builder: (context, state) {
        return switch (state) {
          PokemonSearchInitial() => SliverFillRemaining(
            child: Center(
              child: Text(
                'Digite para buscar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          PokemonSearchLoading() => const SliverFillRemaining(
            child: LoadingWidget(),
          ),
          PokemonSearchSuccess(:final pokemons) => _PokemonGridBuilder(
            pokemons: pokemons,
            listCubit: _listCubit,
          ),
          PokemonSearchEmpty(:final query) => SliverFillRemaining(
            child: EmptySearchWidget(query: query),
          ),
          PokemonSearchError(:final message) => SliverFillRemaining(
            child: ErrorDisplayWidget(
              message: message,
              onRetry: null,
            ),
          ),
        };
      },
    );
  }
}

class _PokemonListContent extends StatelessWidget {
  final PokemonsListCubit listCubit;
  final VoidCallback onRetry;

  const _PokemonListContent({
    required this.listCubit,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonsListCubit, PokemonsListState>(
      bloc: listCubit,
      builder: (context, state) {
        return switch (state) {
          PokemonsListInitial() ||
          PokemonsListLoading() => const SliverFillRemaining(
            child: LoadingWidget(),
          ),
          PokemonsListSuccess(:final pokemons, :final allPokemons) =>
            PokemonGridWidget(
              pokemons: pokemons,
              allPokemons: allPokemons,
            ),
          PokemonsListError(:final message) => SliverFillRemaining(
            child: ErrorDisplayWidget(
              message: message,
              onRetry: onRetry,
            ),
          ),
        };
      },
    );
  }
}

class _PokemonGridBuilder extends StatelessWidget {
  final List<Pokemon> pokemons;
  final PokemonsListCubit listCubit;

  const _PokemonGridBuilder({
    required this.pokemons,
    required this.listCubit,
  });

  @override
  Widget build(BuildContext context) {
    final allPokemons = listCubit.state is PokemonsListSuccess
        ? (listCubit.state as PokemonsListSuccess).allPokemons
        : null;

    return PokemonGridWidget(
      pokemons: pokemons,
      allPokemons: allPokemons,
    );
  }
}
