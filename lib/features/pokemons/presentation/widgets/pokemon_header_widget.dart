import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_serasa/core/theme/app_colors.dart';
import 'package:pokedex_serasa/core/theme/app_text_styles.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/pokemon_search_field.dart';

class PokemonHeaderWidget extends StatelessWidget {
  final Function(String)? onSearch;
  final VoidCallback? onClearSearch;
  final Color? foregroundColor;
  final bool isHomePage;
  final Pokemon? pokemon;

  const PokemonHeaderWidget({
    this.onSearch,
    this.onClearSearch,
    this.foregroundColor,
    this.isHomePage = true,
    this.pokemon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: foregroundColor ?? AppColors.primaryRed,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      expandedHeight: isHomePage
          ? MediaQuery.sizeOf(context).height * 0.7
          : MediaQuery.sizeOf(context).height * 0.5,
      toolbarHeight: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: foregroundColor ?? AppColors.primaryRed,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      top: statusBarHeight + 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isHomePage
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          pokemon?.name ?? 'Pokédex',
                          style: AppTextStyles.appBarTitle,
                        ),
                        const SizedBox(height: 8),
                        if (isHomePage) ...[
                          SvgPicture.asset(
                            'assets/images/pokeball.svg',
                            width: 24,
                            height: 24,
                          ),
                        ] else ...[
                          Text(
                            pokemon?.num != null
                                ? '#${pokemon!.num.padLeft(3, '0')}'
                                : '',
                            style: AppTextStyles.appBarTitle.copyWith(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: pokemon?.img != null
                  ? Hero(
                      tag: 'pokemon-${pokemon!.id}',
                      child: Image.network(
                        pokemon!.img,
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(
                      'assets/images/koraidon.png',
                      width: double.infinity,
                    ),
            ),
            if (isHomePage) ...[
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withAlpha(250),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      'Explore o incrível mundo dos Pokémon.',
                      style: AppTextStyles.displayMedium,
                    ),
                    Text(
                      'Descubra informações detalhadas sobre seus personagens favoritos.',
                      style: AppTextStyles.subtitle,
                    ),
                    Row(
                      children: [
                        Text(
                          '+1000k',
                          style: AppTextStyles.pokemonCounter,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pokémons',
                          style: AppTextStyles.pokemonCounterLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottom: isHomePage
          ? PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Container(
                color: Colors.white,
                child: PokemonSearchField(
                  onSearch: onSearch,
                  onClear: onClearSearch,
                ),
              ),
            )
          : null,
    );
  }
}
