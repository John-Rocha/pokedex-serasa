import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_colors.dart';

class PokemonSearchField extends StatefulWidget {
  final Function(String value)? onSearch;
  final VoidCallback? onClear;

  const PokemonSearchField({
    this.onSearch,
    this.onClear,
    super.key,
  });

  @override
  State<PokemonSearchField> createState() => _PokemonSearchFieldState();
}

class _PokemonSearchFieldState extends State<PokemonSearchField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch?.call(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Semantics(
        textField: true,
        label: 'Campo de busca de pokémons',
        hint: 'Digite o nome ou número do pokémon',
        child: TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Buscar Pokémon por nome ou número',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Semantics(
              label: 'Ícone de busca',
              child: const Icon(
                Icons.search,
                color: AppColors.primaryRed,
              ),
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? Semantics(
                    button: true,
                    label: 'Limpar busca',
                    hint: 'Toque duas vezes para limpar',
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: _clearSearch,
                      tooltip: 'Limpar busca',
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryRed,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
