import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/utils/pokemon_type_colors.dart';
import 'package:pokedex_serasa/features/pokemons/domain/entities/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonCard({
    required this.pokemon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.type.isNotEmpty ? pokemon.type.first : 'normal';
    final typeColor = PokemonTypeColors.getTypeColor(primaryType);
    final typesText = pokemon.type.join(', ');

    return Semantics(
      button: true,
      enabled: onTap != null,
      label:
          'Pokémon ${pokemon.name}, número ${pokemon.pokeNum}, tipos: $typesText',
      hint: 'Toque duas vezes para ver detalhes',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: typeColor.withAlpha(25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: typeColor.withAlpha(76),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Hero(
                    tag: 'pokemon-${pokemon.id}',
                    child: Semantics(
                      image: true,
                      label: 'Imagem do pokémon ${pokemon.name}',
                      child: ExcludeSemantics(
                        child: CachedNetworkImage(
                          imageUrl: pokemon.img,
                          fit: BoxFit.contain,
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 100),
                          placeholder: (context, url) => Semantics(
                            label: 'Carregando imagem',
                            child: Container(
                              decoration: BoxDecoration(
                                color: typeColor.withAlpha(13),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    typeColor,
                                  ),
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Semantics(
                            label: 'Erro ao carregar imagem',
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.catching_pokemon,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Text(
                        '#${pokemon.pokeNum}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    ExcludeSemantics(
                      child: Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ExcludeSemantics(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        alignment: WrapAlignment.center,
                        children: pokemon.type
                            .take(2)
                            .map(
                              (type) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: PokemonTypeColors.getTypeColor(type),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  type,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
