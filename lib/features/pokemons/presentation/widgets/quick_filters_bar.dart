import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/filter_chip_widget.dart';

class QuickFiltersBar extends StatelessWidget {
  final SortOrder currentSortOrder;
  final VoidCallback onFiltersTap;
  final Function(SortOrder) onSortOrderChanged;

  const QuickFiltersBar({
    required this.currentSortOrder,
    required this.onFiltersTap,
    required this.onSortOrderChanged,
    super.key,
  });

  String _getCodeSortLabel(SortOrder sortOrder) {
    return sortOrder == SortOrder.idDescending
        ? 'código (decrescente)'
        : 'código (crescente)';
  }

  SortOrder _getNextCodeSortOrder(SortOrder currentOrder) {
    return currentOrder == SortOrder.idDescending
        ? SortOrder.none
        : SortOrder.idDescending;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChipWidget(
              label: 'Filtro',
              isActive: false,
              icon: Icons.tune,
              onTap: onFiltersTap,
            ),
            const SizedBox(width: 8),

            FilterChipWidget(
              label: 'alfabética (A-Z)',
              isActive: currentSortOrder == SortOrder.alphabetical,
              onTap: () {
                onSortOrderChanged(
                  currentSortOrder == SortOrder.alphabetical
                      ? SortOrder.none
                      : SortOrder.alphabetical,
                );
              },
            ),
            const SizedBox(width: 8),

            FilterChipWidget(
              label: _getCodeSortLabel(currentSortOrder),
              isActive: currentSortOrder == SortOrder.idDescending,
              onTap: () {
                onSortOrderChanged(_getNextCodeSortOrder(currentSortOrder));
              },
            ),
          ],
        ),
      ),
    );
  }
}
