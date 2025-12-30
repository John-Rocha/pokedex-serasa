import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/enums/sort_order.dart';
import 'package:pokedex_serasa/core/theme/app_colors.dart';
import 'package:pokedex_serasa/features/pokemons/presentation/widgets/filter_chip_widget.dart'
    as custom;

class AdvancedFiltersBottomSheet extends StatefulWidget {
  final SortOrder currentSortOrder;
  final String? selectedType;
  final List<String> availableTypes;
  final Function(SortOrder, String?) onApplyFilters;

  const AdvancedFiltersBottomSheet({
    required this.currentSortOrder,
    required this.selectedType,
    required this.availableTypes,
    required this.onApplyFilters,
    super.key,
  });

  @override
  State<AdvancedFiltersBottomSheet> createState() =>
      _AdvancedFiltersBottomSheetState();
}

class _AdvancedFiltersBottomSheetState
    extends State<AdvancedFiltersBottomSheet> {
  late SortOrder _selectedSortOrder;
  late String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedSortOrder = widget.currentSortOrder;
    _selectedType = widget.selectedType;
  }

  void _clearFilters() {
    setState(() {
      _selectedSortOrder = SortOrder.none;
      _selectedType = null;
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(_selectedSortOrder, _selectedType);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Filtros avançados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Semantics(
                    button: true,
                    label: 'Limpar todos os filtros',
                    hint: 'Toque duas vezes para remover todos os filtros aplicados',
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                        side: const BorderSide(color: AppColors.primaryRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Limpar'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    custom.FilterChipWidget(
                      label: 'alfabética (A-Z)',
                      isActive: _selectedSortOrder == SortOrder.alphabetical,
                      onTap: () {
                        setState(() {
                          _selectedSortOrder =
                              _selectedSortOrder == SortOrder.alphabetical
                              ? SortOrder.none
                              : SortOrder.alphabetical;
                        });
                      },
                    ),
                    custom.FilterChipWidget(
                      label: 'código (crescente)',
                      isActive: _selectedSortOrder == SortOrder.idAscending,
                      onTap: () {
                        setState(() {
                          _selectedSortOrder =
                              _selectedSortOrder == SortOrder.idAscending
                              ? SortOrder.none
                              : SortOrder.idAscending;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Tipo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    hintText: 'Fogo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todos'),
                    ),
                    ...widget.availableTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Ordenar por',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<SortOrder>(
                  initialValue: _selectedSortOrder,
                  decoration: InputDecoration(
                    hintText: 'Código (crescente)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: SortOrder.values.map((order) {
                    return DropdownMenuItem<SortOrder>(
                      value: order,
                      child: Text(order.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSortOrder = value ?? SortOrder.none;
                    });
                  },
                ),
                const SizedBox(height: 24),

                Semantics(
                  button: true,
                  label: 'Aplicar filtros selecionados',
                  hint: 'Toque duas vezes para aplicar os filtros e fechar',
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Aplicar Filtros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
