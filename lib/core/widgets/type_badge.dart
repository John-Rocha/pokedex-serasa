import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_text_styles.dart';
import 'package:pokedex_serasa/core/utils/pokemon_type_colors.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  final double fontSize;
  final EdgeInsets padding;

  const TypeBadge({
    required this.type,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tipo ${type.toLowerCase()}',
      child: ExcludeSemantics(
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: PokemonTypeColors.getTypeColor(type),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getTypeIcon(type),
                color: Colors.white,
                size: fontSize + 2,
              ),
              const SizedBox(width: 4),
              Text(
                type.toLowerCase(),
                style: AppTextStyles.bodySmallRegular,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'water':
        return Icons.water_drop;
      case 'grass':
        return Icons.grass;
      case 'electric':
        return Icons.electric_bolt;
      case 'ice':
        return Icons.ac_unit;
      case 'fighting':
        return Icons.sports_mma;
      case 'poison':
        return Icons.science;
      case 'ground':
        return Icons.terrain;
      case 'flying':
        return Icons.air;
      case 'psychic':
        return Icons.psychology;
      case 'bug':
        return Icons.bug_report;
      case 'rock':
        return Icons.landscape;
      case 'ghost':
        return Icons.nights_stay;
      case 'dragon':
        return Icons.whatshot;
      case 'dark':
        return Icons.dark_mode;
      case 'steel':
        return Icons.shield;
      case 'fairy':
        return Icons.star;
      default:
        return Icons.circle;
    }
  }
}
